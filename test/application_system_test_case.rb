# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def setup
    # Fix Devise mapping not found error in Rails 8 when running these spec types directly
    # https://github.com/heartcombo/devise/issues/5774#issuecomment-2944728967
    Rails.application.try(:reload_routes_unless_loaded)
  end
end
