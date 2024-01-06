require "application_system_test_case"

class AdminUsersTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_admin_users_path

    assert_text "Admin Users"
    assert_text "Showing 1 of 1"
    assert_text "admin@example.com"
  end

  test "visiting the show" do
    sign_in default_admin_user

    visit admin_admin_user_path(default_admin_user)

    assert_text "admin@example.com"
    assert_selector "a", text: "Edit Admin User"
    assert_selector "a", text: "Delete Admin User"
  end

  test "visiting the new and submitting" do
    sign_in default_admin_user

    visit new_admin_admin_user_path

    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: "password", id: "admin_user_password"
    fill_in "Password confirmation", with: "password"
    click_on "Create Admin user"

    assert_text "Admin user was successfully created."
    assert_text "test@test.com"
  end

  test "visiting the edit" do
    sign_in default_admin_user

    visit edit_admin_admin_user_path(default_admin_user)

    assert_text "admin@example.com"
  end
end
