require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "visiting the root redirects to admin login" do
    visit root_path

    assert_current_path new_admin_user_session_path
    assert_text "Active Admin Demo Sign In"
  end

  test "submitting the login form successfully" do
    default_admin_user

    visit new_admin_user_session_path

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_on "Sign In"

    assert_current_path admin_root_path
    assert_text "Welcome to ActiveAdmin"
  end
end
