require "test_helper"

class RoomTest < ActiveSupport::TestCase
  test "deleting a room is successful" do
    room = rooms(:one)

    assert room.sessions.any?
    assert room.speakers.any?

    assert_no_difference -> { Venue.count } do
      assert_difference -> { Room.count }, -1 do
        room.destroy
      end
    end

    refute room.sessions.any?
    refute room.speakers.any?
  end
end
