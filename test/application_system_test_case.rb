# frozen_string_literal: true

require "test_helper"

# Chrome raises a generic UnknownError ("Node with given id does not belong to
# the document") when the DOM is replaced mid-query. Treat it like a stale
# element so Capybara's synchronize retries the query instead of failing.
Capybara::Selenium::Driver.prepend(Module.new do
  def invalid_element_errors
    @invalid_element_errors_with_unknown ||=
      super + [Selenium::WebDriver::Error::UnknownError]
  end
end)

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end
