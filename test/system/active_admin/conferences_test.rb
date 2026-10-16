# frozen_string_literal: true

require "application_system_test_case"

class ConferencesTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_conferences_path

    assert_text "Conferences"
    assert_text "Showing all #{Conference.count}"
    assert_text conferences(:one).name
  end

  test "visiting the show" do
    conference = conferences(:one)
    sign_in default_admin_user

    visit admin_conference_path(conference)

    assert_text conference.name
    assert_text conference.description
    assert_link "Edit Conference", href: edit_admin_conference_path(conference)
    assert_link "Delete Conference", href: admin_conference_path(conference)
  end

  test "action item toggles published status" do
    conference = conferences(:one)
    assert_not_predicate conference, :published?
    sign_in default_admin_user

    visit admin_conference_path(conference)
    click_on I18n.t("admin.conference.action_items.publish")

    assert_current_path admin_conference_path(conference)
    assert_text I18n.t("admin.conference.action_items.toggle_published_notice")
    assert_link I18n.t("admin.conference.action_items.unpublish"), href: toggle_published_admin_conference_path(conference)
    assert_predicate conference.reload, :published?
  end

  test "visiting the new form" do
    sign_in default_admin_user

    visit new_admin_conference_path

    assert_text "New Conference"
    assert_selector "input", id: "conference_name"
    assert_selector "select", id: "conference_venue_id"
  end

  test "visiting the edit" do
    conference = conferences(:one)
    sign_in default_admin_user

    visit edit_admin_conference_path(conference)

    assert_text conference.name
    assert_text conference.description
  end

  test "invalid conference creation is rejected" do
    sign_in default_admin_user

    assert_no_difference -> { Conference.count } do
      visit new_admin_conference_path
      assert_button "Create Conference"
      click_on "Create Conference"

      assert_text "can't be blank"
    end
  end

  test "invalid conference updates are rejected" do
    conference = conferences(:one)
    original_name = conference.name
    assert_predicate conference.name, :present?
    sign_in default_admin_user

    visit edit_admin_conference_path(conference)
    assert_button "Update Conference"
    fill_in "Name", with: ""
    click_on "Update Conference"

    assert_text "can't be blank"
    assert_equal original_name, conference.reload.name
  end

  test "updating a conference is successful" do
    conference = conferences(:one)
    sign_in default_admin_user

    visit edit_admin_conference_path(conference)
    fill_in "Name", with: "Sample Conference Name"
    fill_in "conference_description", with: "A plain conference description"
    click_on "Update Conference"

    assert_current_path admin_conference_path(conference)
    assert_text "Conference was successfully updated."
    assert_text "Sample Conference Name"
    assert_text "A plain conference description"
    assert_equal "A plain conference description", conference.reload.description
  end

  test "deleting a conference is successful" do
    conference = conferences(:one)
    sign_in default_admin_user

    visit admin_conference_path(conference)
    accept_confirm { click_on "Delete Conference" }

    assert_current_path admin_conferences_path
    assert_text "Conference was successfully destroyed."
  end

  test "batch action toggles published status" do
    published = conferences(:one).tap { it.update_columns(published: true) }
    unpublished = conferences(:two).tap { it.update_columns(published: false) }
    sign_in default_admin_user

    visit admin_conferences_path
    check "batch_action_item_#{published.id}"
    check "batch_action_item_#{unpublished.id}"
    click_on "Batch Actions"
    accept_confirm I18n.t("admin.conference.batch_actions.toggle_published_confirmation") do
      click_on "Toggle Published"
    end

    assert_text I18n.t("admin.conference.batch_actions.toggle_published_notice")
    assert_not published.reload.published?
    assert unpublished.reload.published?
  end

  test "program editor creates a session and its speaker together" do
    conference = conferences(:one)
    sign_in default_admin_user
    visit edit_admin_conference_path(conference)
    assert_no_selector '.has-many-container input[name$="[position]"], [draggable]', visible: :all
    click_on "Add session"
    within all("fieldset.program-session").last do
      fill_in "Title", with: "Program editor talk"
      fill_in "Description", with: "Created with a nested speaker"
      find("select[id$='_room_id'] option[value='#{rooms(:one).id}']").select_option
      find("input[id$='_starts_at']").set(Time.utc(2026, 9, 25, 9))
      find("input[id$='_ends_at']").set(Time.utc(2026, 9, 25, 10))
      click_on "Add speaker"
      select "John Smith", from: "Speaker"
    end
    click_on "Update Conference"
    assert_current_path admin_conference_path(conference)
    assert_text "Program editor talk"
    session = conference.sessions.find_by!(title: "Program editor talk")
    assert_equal [speakers(:two)], session.speakers
  end
end
