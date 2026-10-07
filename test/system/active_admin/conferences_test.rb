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
    assert_link I18n.t("admin.conference.action_items.clone"), href: clone_as_draft_admin_conference_path(conference)
    assert_link I18n.t("admin.conference.action_items.readiness"), href: readiness_admin_conference_path(conference)
  end

  test "cloning a conference as a draft" do
    conference = conferences(:one)
    sign_in default_admin_user

    visit admin_conference_path(conference)
    click_on I18n.t("admin.conference.action_items.clone")
    fill_in "Name", with: "Next conference"
    fill_in "Slug", with: "next-conference"
    fill_in "New start date", with: Date.new(2027, 9, 24)
    fill_in "New end date", with: Date.new(2027, 9, 24)
    uncheck I18n.t("admin.conference.clone.include_speakers")
    click_on I18n.t("admin.conference.clone.submit")

    assert_text I18n.t("admin.conference.clone.notice")
    copy = Conference.find_by!(slug: "next-conference")
    assert_current_path edit_admin_conference_path(copy)
    assert_predicate copy, :draft?
    assert_not_predicate copy, :published?
    assert_equal conference.sessions.count, copy.sessions.count
    assert_empty copy.session_speakers
  end

  test "action item toggles published status" do
    conference = conferences(:one)
    make_program_ready(conference)
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
    click_on "Update Conference"

    assert_current_path admin_conference_path(conference)
    assert_text "Conference was successfully updated."
    assert_text "Sample Conference Name"
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
    make_program_ready(unpublished)
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

  test "publishing an incomplete program opens the readiness report" do
    conference = conferences(:one)
    sign_in default_admin_user

    visit admin_conference_path(conference)
    click_on I18n.t("admin.conference.action_items.publish")

    assert_current_path readiness_admin_conference_path(conference)
    assert_text I18n.t("admin.conference.readiness.publish_blocked")
    assert_link "Edit #{sessions(:one).title}", href: edit_admin_session_path(sessions(:one))
    assert_not_predicate conference.reload, :published?
  end

  test "fixing missing speakers through a readiness edit link allows publishing" do
    conference = conferences(:one)
    session = sessions(:one)
    session.update!(ends_at: session.starts_at + 1.hour)
    session.session_speakers.destroy_all
    sign_in default_admin_user

    visit readiness_admin_conference_path(conference)
    click_on "Edit #{session.title}"
    click_on "Add New Session speaker"
    select speakers(:one).full_name, from: "Speaker"
    click_on "Update Session"

    assert_text "Session was successfully updated."
    visit readiness_admin_conference_path(conference)
    assert_text I18n.t("admin.conference.readiness.ready")
    click_on I18n.t("admin.conference.action_items.publish")

    assert_current_path admin_conference_path(conference)
    assert_predicate conference.reload, :published?
  end

  private

  def make_program_ready(conference)
    conference.sessions.each do |session|
      session.update!(ends_at: session.starts_at + 1.hour)
      session.session_speakers.create!(speaker: speakers(:one)) if session.session_speakers.empty?
    end
  end
end
