require "test_helper"

class ConferenceClonerTest < ActiveSupport::TestCase
  setup do
    @source = conferences(:one)
    @source.update!(start_date: Date.new(2026, 10, 30), end_date: Date.new(2026, 10, 31))
    @source.update_columns(published: true)
    zone = @source.venue.time_zone
    sessions(:one).update!(starts_at: Time.find_zone!(zone).local(2026, 10, 31, 9), ends_at: Time.find_zone!(zone).local(2026, 10, 31, 10))
    @attributes = { name: "Next conference", slug: "next-conference", start_date: "2026-11-06", end_date: "2026-11-07" }
  end

  test "copies a complete draft program and keeps local times across daylight saving changes" do
    source_attributes = @source.attributes
    session_attributes = sessions(:one).attributes
    cloner = ConferenceCloner.new(@source, @attributes)

    assert_no_difference [-> { Venue.count }, -> { Room.count }, -> { Speaker.count }] do
      assert_difference [-> { Conference.count }, -> { Session.count }, -> { SessionSpeaker.count }], 1 do
        assert cloner.save, cloner.errors.full_messages.to_sentence
      end
    end

    copy = cloner.conference.reload
    session = copy.sessions.sole
    assert_predicate copy, :draft?
    assert_not_predicate copy, :published?
    assert_equal @attributes[:name], copy.name
    assert_equal @attributes[:slug], copy.slug
    assert_equal Date.new(2026, 11, 6), copy.start_date
    assert_equal Date.new(2026, 11, 7), copy.end_date
    assert_equal @source.venue, copy.venue
    assert_equal @source.description, copy.description
    assert_predicate session, :draft?
    assert_equal sessions(:one).room, session.room
    assert_equal sessions(:one).speakers, session.speakers
    assert_equal "2026-11-07 09:00 -0500", session.starts_at.in_time_zone(copy.venue.time_zone).strftime("%F %H:%M %z")
    assert_equal 1.hour, session.ends_at - session.starts_at
    assert_equal source_attributes, @source.reload.attributes
    assert_equal session_attributes, sessions(:one).reload.attributes
  end

  test "speaker assignments can be omitted" do
    cloner = ConferenceCloner.new(@source, @attributes.merge(include_speakers: "0"))

    assert_no_difference -> { SessionSpeaker.count } do
      assert cloner.save
    end
    assert_empty cloner.conference.sessions.sole.speakers
  end

  test "copies every session as a draft including cancelled sessions" do
    sessions(:one).update!(status: :cancelled)
    second = sessions(:one).dup
    second.title = "Another session"
    second.save!
    cloner = ConferenceCloner.new(@source, @attributes)

    assert_difference -> { Session.count }, 2 do
      assert cloner.save
    end
    assert cloner.conference.sessions.all?(&:draft?)
  end

  test "requires dates in order and an unused slug" do
    cloner = ConferenceCloner.new(@source, @attributes.merge(slug: @source.slug, end_date: "2026-11-05"))

    assert_no_difference [-> { Conference.count }, -> { Session.count }, -> { SessionSpeaker.count }] do
      assert_not cloner.save
    end
    assert_equal [:taken], cloner.errors.details[:slug].pluck(:error)
    assert_equal [:before_start_date], cloner.errors.details[:end_date].pluck(:error)

    cloner.start_date = "invalid date"
    assert_not cloner.valid?
    assert_equal [:blank], cloner.errors.details[:start_date].pluck(:error)
  end

  test "rolls back the whole copy if a session cannot be saved" do
    sessions(:one).update_columns(title: "")
    cloner = ConferenceCloner.new(@source, @attributes)

    assert_no_difference [-> { Conference.count }, -> { Session.count }, -> { SessionSpeaker.count }] do
      assert_not cloner.save
    end
    assert_predicate cloner.errors[:base], :present?
  end
end
