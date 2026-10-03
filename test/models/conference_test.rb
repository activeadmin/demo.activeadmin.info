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
end
