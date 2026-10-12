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
    assert_link "Edit Session", href: edit_admin_session_path(session)
    assert_link "Delete Session", href: admin_session_path(session)
  end

  test "action item cancels a session" do
    session = sessions(:one)
    assert_not_predicate session, :cancelled?
    sign_in default_admin_user

    visit admin_session_path(session)
    click_on I18n.t("admin.session.action_items.cancel")

    assert_text I18n.t("admin.session.action_items.cancelled_notice")
    assert_text(/Status Cancelled/i)
    assert_predicate session.reload, :cancelled?
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

  test "invalid session creation is rejected" do
    sign_in default_admin_user

    assert_no_difference -> { Session.count } do
      visit new_admin_session_path
      assert_button "Create Session"
      click_on "Create Session"

      assert_text "can't be blank"
    end
  end

  test "invalid session updates are rejected" do
    session = sessions(:one)
    original_title = session.title
    assert_predicate session.title, :present?
    sign_in default_admin_user

    visit edit_admin_session_path(session)
    assert_button "Update Session"
    fill_in "Title", with: ""
    click_on "Update Session"

    assert_text "can't be blank"
    assert_equal original_title, session.reload.title
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

  test "batch action rejects invalid enum values" do
    session = sessions(:one)
    session.update_columns(status: :draft, session_type: :plenary, audience_level: :all_levels)
    sign_in default_admin_user

    visit admin_sessions_path
    check "batch_action_item_#{session.id}"
    click_on "Batch Actions"
    click_on "Update Session Details"
    # Simulate submitting an invalid enum value to fail validation check
    execute_script("document.querySelector('#session-status option').value = '999'")
    click_on "Update sessions"

    assert_text I18n.t("admin.session.batch_actions.update_session_details_invalid")
    assert_predicate session.reload, :draft?
    assert_predicate session, :plenary?
    assert_predicate session, :all_levels?
  end

  test "session editor adds a speaker and removes an existing assignment" do
    session = sessions(:one)
    sign_in default_admin_user
    visit edit_admin_session_path(session)
    within "fieldset.program-speakers" do
      check "Delete"
    end
    click_on "Add speaker"
    within all("fieldset.program-speakers").last do
      select "John Smith", from: "Speaker"
    end
    click_on "Update Session"
    assert_current_path admin_session_path(session)
    assert_equal [speakers(:two)], session.speakers.reload
  end
end
