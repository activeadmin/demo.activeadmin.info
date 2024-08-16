require "application_system_test_case"

class RouteNotFoundTest < ApplicationSystemTestCase
  test "visiting non-existent route renders 404 page" do
    visit "/does-not-exist"

    assert_text "The page you were looking for doesn't exist."
  end
end
