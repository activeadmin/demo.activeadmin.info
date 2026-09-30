# frozen_string_literal: true

require "application_system_test_case"

class SignInTest < ApplicationSystemTestCase
  test "visiting the root redirects to admin login" do
    visit root_path

    assert_current_path new_admin_user_session_path
    assert_text "Active Admin Demo Sign In"
  end

  test "submitting the login form successfully" do
    default_admin_user

    visit new_admin_user_session_path

    fill_in "Email", with: AdminUser::DEFAULT_EMAIL
    fill_in "Password", with: "password"
    click_on "Sign In"

    assert_current_path admin_root_path
    assert_text "Welcome to ActiveAdmin"
  end

  test "submitting invalid credentials is rejected" do
    default_admin_user

    visit new_admin_user_session_path

    fill_in "Email", with: AdminUser::DEFAULT_EMAIL
    fill_in "Password", with: "wrong-password"
    click_on "Sign In"

    assert_current_path new_admin_user_session_path
    assert_text I18n.t("devise.failure.invalid", authentication_keys: "email")
  end

  test "visiting an admin path when signed out redirects to sign in" do
    visit admin_sessions_path

    assert_current_path new_admin_user_session_path
    assert_text "Active Admin Demo Sign In"
  end
end
