require "test_helper"

class ConferenceTest < ActiveSupport::TestCase
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
