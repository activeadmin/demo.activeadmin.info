require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "requires title, description, starts_at, ends_at, conference, and room" do
    session = sessions(:one).dup
    assert_predicate session, :valid?
    session.assign_attributes(
      title: nil,
      description: nil,
      starts_at: nil,
      ends_at: nil,
      conference: nil,
      room: nil
    )

    assert_predicate session, :invalid?
    %i[title description starts_at ends_at conference room].each do |attribute|
      assert_predicate session.errors[attribute], :present?
    end
  end

  test "requires a valid status" do
    session = sessions(:one).dup
    session.status = nil

    assert_predicate session, :invalid?
    assert_includes session.errors[:status], "is not included in the list"

    session.status = :bogus

    assert_predicate session, :invalid?
    assert_includes session.errors[:status], "is not included in the list"
  end

  test "allows a blank session type but rejects an invalid value" do
    session = sessions(:one).dup
    session.session_type = nil

    assert_predicate session, :valid?

    session.session_type = :bogus

    assert_predicate session, :invalid?
    assert_includes session.errors[:session_type], "is not included in the list"
  end

  test "allows a blank audience level but rejects an invalid value" do
    session = sessions(:one).dup
    session.audience_level = nil

    assert_predicate session, :valid?

    session.audience_level = :bogus

    assert_predicate session, :invalid?
    assert_includes session.errors[:audience_level], "is not included in the list"
  end

  test "deleting a session is successful" do
    session = sessions(:one)

    assert_no_difference [-> { Conference.count }, -> { Room.count }, -> { Speaker.count }] do
      assert_difference -> { Session.count } => -1, -> { SessionSpeaker.count } => -1 do
        session.destroy
      end
    end
  end

  test "requires an end after the start and a room in the conference venue" do
    session = sessions(:one)
    session.ends_at = session.starts_at
    session.room = rooms(:two)

    assert_predicate session, :invalid?
    assert_includes session.errors[:ends_at], I18n.t!("activerecord.errors.models.session.attributes.ends_at.after_start")
    assert_includes session.errors[:room], I18n.t!("activerecord.errors.models.session.attributes.room.wrong_venue")
  end

  test "nested speaker assignments cannot duplicate a speaker" do
    session = sessions(:one)
    session.session_speakers.build(speaker: speakers(:one))

    assert_predicate session, :invalid?
    assert_includes session.errors[:session_speakers], I18n.t!("activerecord.errors.models.session.attributes.session_speakers.duplicate_speaker")
  end

end
