# frozen_string_literal: true

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

    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password", id: "admin_user_password"
    fill_in "Password confirmation", with: "password"
    click_on "Create Admin user"

    assert_text "Admin user was successfully created."
    assert_current_path admin_admin_user_path(AdminUser.last)
    assert_text "test@example.com"
  end

  test "visiting the edit" do
    sign_in default_admin_user

    visit edit_admin_admin_user_path(default_admin_user)

    assert_text "admin@example.com"
  end

  test "updating an admin user is successful" do
    admin_user = AdminUser.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    sign_in default_admin_user

    visit edit_admin_admin_user_path(admin_user)
    fill_in "Email", with: "updated@example.com"
    fill_in "Password", with: "password", id: "admin_user_password"
    fill_in "Password confirmation", with: "password"
    click_on "Update Admin user"

    assert_current_path admin_admin_user_path(admin_user)
    assert_text "Admin user was successfully updated."
    assert_text "updated@example.com"
    refute_text "test@example.com"
  end

  test "updating the default admin user is blocked" do
    sign_in default_admin_user

    visit edit_admin_admin_user_path(default_admin_user)
    fill_in "Email", with: "test@example.com"
    click_on "Update Admin user"

    default_admin_user.reload
    assert_current_path edit_admin_admin_user_path(default_admin_user)
    assert_text "The default admin user cannot be modified."
    refute_equal default_admin_user.email, "test@example.com"
  end

  test "deleting an admin user is successful" do
    admin_user = AdminUser.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    sign_in default_admin_user

    visit admin_admin_user_path(admin_user)
    accept_confirm do
      click_on "Delete Admin User"
    end

    assert_current_path admin_admin_users_path
    assert_text "Admin user was successfully destroyed."
    refute_text "test@example.com"
  end

  test "deleting the default admin user is blocked" do
    sign_in default_admin_user

    visit admin_admin_user_path(default_admin_user)
    accept_confirm do
      click_on "Delete Admin User"
    end

    default_admin_user.reload
    assert_current_path admin_admin_user_path(default_admin_user)
    assert_text "The default admin user cannot be modified."
  end
end
