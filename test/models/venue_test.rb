require "test_helper"

class VenueTest < ActiveSupport::TestCase
  test "#coordinates" do
    venue = Venue.new(latitude: 40.7128, longitude: -74.0060)

    assert_equal [40.7128, -74.0060], venue.coordinates
  end
end
