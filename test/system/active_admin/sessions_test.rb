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

  test "batch action form updates selected session attributes" do
    first = sessions(:one)
    second = sessions(:two)
    first.update_columns(status: :draft, session_type: :plenary, audience_level: :all_levels)
    second.update_columns(status: :scheduled, session_type: :talk, audience_level: :beginner)
    unselected = sessions(:three)
    sign_in default_admin_user

    visit admin_sessions_path
    check "batch_action_item_#{first.id}"
    check "batch_action_item_#{second.id}"
    click_on "Batch Actions"
    click_on "Update Session Details"
    select "Cancelled", from: "Status"
    select "Discussion", from: "Session type"
    select "Advanced", from: "Audience level"
    click_on "Update sessions"

    assert_text I18n.t("admin.session.batch_actions.update_session_details_notice")
    [first, second].each do |session|
      assert_predicate session.reload, :cancelled?
      assert_predicate session, :discussion?
      assert_predicate session, :advanced?
    end
    assert_predicate unselected.reload, :draft?
    assert_nil unselected.session_type
    assert_nil unselected.audience_level
  end
end
