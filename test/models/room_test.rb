require "test_helper"

class RoomTest < ActiveSupport::TestCase
  test "requires a venue, name, positive capacity, and numeric area" do
    room = rooms(:one).dup
    assert_predicate room, :valid?
    room.venue = nil
    room.name = nil
    room.capacity = 0
    room.area_sq_ft = "not-a-number"

    assert_predicate room, :invalid?
    assert_includes room.errors[:venue], "must exist"
    assert_includes room.errors[:name], "can't be blank"
    assert_includes room.errors[:capacity], "must be greater than 0"
    assert_includes room.errors[:area_sq_ft], "is not a number"
  end

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
