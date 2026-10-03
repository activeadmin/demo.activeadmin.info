require "test_helper"

class VenueTest < ActiveSupport::TestCase
  test "#coordinates" do
    venue = Venue.new(latitude: 40.7128, longitude: -74.0060)

    assert_equal [40.7128, -74.0060], venue.coordinates
  end

  test "#coordinates is nil unless both coordinates are present" do
    assert_nil Venue.new(latitude: 40.7128).coordinates
    assert_nil Venue.new(longitude: -74.0060).coordinates
    assert_nil Venue.new.coordinates
  end

  test "validates timezone, numeric coordinates, and non-negative capacity" do
    venue = venues(:one).dup
    assert_predicate venue, :valid?
    venue.time_zone = "Bogus"
    venue.latitude = "not-a-number"
    venue.longitude = "not-a-number"
    venue.capacity = -1

    assert_predicate venue, :invalid?
    assert_predicate venue.errors[:time_zone], :present?
    assert_includes venue.errors[:latitude], "is not a number"
    assert_includes venue.errors[:longitude], "is not a number"
    assert_includes venue.errors[:capacity], "must be greater than or equal to 0"
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
