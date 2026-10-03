# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "formats time in the current time zone with default format" do
    time = Time.zone.local(2026, 9, 30, 16, 5)
    assert_equal "Sep 30, 2026 04:05PM UTC", format_time(time)
  end

  test "formats time in the current time zone with a specified format" do
    time = Time.zone.local(2026, 9, 30, 16, 5)
    assert_equal "September 30, 2026 16:05", format_time(time, format: :long)
  end

  test "returns nil for a blank time" do
    assert_nil format_time(nil)
  end
end
