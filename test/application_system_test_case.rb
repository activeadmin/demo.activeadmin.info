# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def bypass_native_form_validation
    execute_script("document.querySelector('form').noValidate = true")
  end
end
