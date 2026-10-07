require "test_helper"

class ConferenceTest < ActiveSupport::TestCase
  test "rejects an invalid status enum value" do
    conference = conferences(:one)
    conference.status = :bogus

    assert_predicate conference, :invalid?
    assert_includes conference.errors[:status], "is not included in the list"
  end

  test "requires name, positive capacity, and non-negative ticket price" do
    conference = conferences(:one).dup
    assert_predicate conference, :valid?
    conference.name = nil
    conference.capacity = 0
    conference.ticket_price = -1

    assert_predicate conference, :invalid?
    assert_includes conference.errors[:name], "can't be blank"
    assert_includes conference.errors[:capacity], "must be greater than 0"
    assert_includes conference.errors[:ticket_price], "must be greater than or equal to 0"
  end

  test "deleting a conference is successful" do
    conference = conferences(:one)

    assert conference.sessions.any?
    assert conference.speakers.any?
    assert conference.session_speakers.any?

    assert_no_difference [-> { Venue.count }, -> { Room.count }] do
      assert_difference -> { Conference.count }, -1 do
        conference.destroy
      end
    end

    refute conference.sessions.any?
    refute conference.speakers.any?
    refute conference.session_speakers.any?
  end

  test "publishing rejects an incomplete program while saving a draft remains possible" do
    conference = conferences(:one)
    conference.published = true

    assert_predicate conference, :invalid?
    assert_includes conference.errors[:base], I18n.t("admin.conference.readiness.issues.invalid_times", title: sessions(:one).title)

    conference.published = false
    assert_predicate conference, :valid?
  end

  test "creating an already published conference requires a ready program" do
    conference = conferences(:one).dup
    conference.slug = "published-conference"
    conference.published = true

    assert_predicate conference, :invalid?
    assert_includes conference.errors[:base], I18n.t("admin.conference.readiness.issues.empty_program")
  end

  test "publishing validates submitted conference dates against the existing sessions" do
    conference = conferences(:one)
    sessions(:one).update!(ends_at: sessions(:one).starts_at + 1.hour)

    assert conference.update(published: true)
    assert_predicate conference, :published?

    conference.update!(published: false)
    conference.assign_attributes(published: true, start_date: Date.new(2027, 9, 24), end_date: Date.new(2027, 9, 24))
    assert_predicate conference, :invalid?
    assert_includes conference.errors[:base], I18n.t("admin.conference.readiness.issues.outside_dates", title: sessions(:one).title)
  end

  test "editing an existing published conference does not run the publication gate again" do
    conference = conferences(:one)
    conference.update_columns(published: true)

    assert conference.update(name: "Updated published conference")
    assert conference.update(published: false)
  end
end
