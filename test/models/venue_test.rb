require "test_helper"

class VenueTest < ActiveSupport::TestCase
  test "#coordinates" do
    venue = Venue.new(latitude: 40.7128, longitude: -74.0060)

    assert_equal [40.7128, -74.0060], venue.coordinates
  end

  test "deleting a venue is successful" do
    venue = venues(:one)

    assert venue.conferences.any?
    assert venue.rooms.any?
    assert venue.sessions.any?
    assert venue.speakers.any?
    assert venue.session_speakers.any?

    assert_difference -> { Venue.count }, -1 do
      venue.destroy
    end

    refute venue.conferences.any?
    refute venue.rooms.any?
    refute venue.sessions.any?
    refute venue.speakers.any?
    refute venue.session_speakers.any?
  end
end
