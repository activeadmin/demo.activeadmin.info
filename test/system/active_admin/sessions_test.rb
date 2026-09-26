# frozen_string_literal: true

require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_sessions_path

    assert_text "Sessions"
    assert_text sessions(:one).title
  end

  test "visiting the show" do
    session = sessions(:one)
    sign_in default_admin_user

    visit admin_session_path(session)

    assert_text session.title
    assert_text session.description
    assert_selector "a", text: "Edit Session"
    assert_selector "a", text: "Delete Session"
  end

  test "visiting the new form" do
    sign_in default_admin_user

    visit new_admin_session_path

    assert_text "New Session"
    assert_selector "input", id: "session_title"
    assert_selector "select", id: "session_conference_id"
    assert_selector "select", id: "session_room_id"
  end

  test "visiting the edit" do
    sign_in default_admin_user

    visit edit_admin_session_path(sessions(:one))

    assert_text sessions(:one).title
  end

  test "updating a session is successful" do
    session = sessions(:one)
    sign_in default_admin_user

    visit edit_admin_session_path(session)
    fill_in "Title", with: "Sample Session Title"
    click_on "Update Session"

    assert_current_path admin_session_path(session)
    assert_text "Session was successfully updated."
    assert_text "Sample Session Title"
  end

  test "deleting a session is successful" do
    session = sessions(:one)
    sign_in default_admin_user

    visit admin_session_path(session)
    accept_confirm { click_on "Delete Session" }

    assert_current_path admin_sessions_path
    assert_text "Session was successfully destroyed."
  end
end
