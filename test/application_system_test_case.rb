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

# Chrome 158 rejects the "*" origin passed to Storage.clearDataForOrigin at the
# end of ChromeDriver#reset!, so the session reset raises instead of running.
# Clear the page storage and the cookies explicitly: the storage of origins
# visited earlier in the test stays, because Chrome has no CDP command that
# clears it. Remove when capybara ships the fix
# (https://github.com/teamcapybara/capybara/issues/2865).
Capybara::Selenium::Driver::ChromeDriver.prepend(Module.new do
  def reset!
    clear_storage
    super
  rescue Selenium::WebDriver::Error::InvalidArgumentError => e
    raise unless e.message.include?("* is not a valid URL")

    delete_all_cookies
  end
end)

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end
