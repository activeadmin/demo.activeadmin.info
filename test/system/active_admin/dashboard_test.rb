# frozen_string_literal: true

require "application_system_test_case"

class AdminUsersTest < ApplicationSystemTestCase
  test "visiting root redirects to admin root" do
    sign_in default_admin_user
    visit root_path
    assert_current_path admin_root_path
    assert_text "Welcome to ActiveAdmin"
  end

  test "visiting the admin root renders dashboard" do
    sign_in default_admin_user
    visit admin_root_path
    assert_text "Welcome to ActiveAdmin"
  end

  test "visiting the admin dashboard" do
    sign_in default_admin_user
    visit admin_dashboard_path
    assert_text "Welcome to ActiveAdmin"
  end
end
