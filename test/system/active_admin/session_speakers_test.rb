# frozen_string_literal: true

require "application_system_test_case"

class SessionSpeakersTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_session_speakers_path

    assert_text "Session Speakers"
    assert_text session_speakers(:one).session.title
  end

  test "visiting the show" do
    session_speaker = session_speakers(:one)
    sign_in default_admin_user

    visit admin_session_speaker_path(session_speaker)

    assert_text session_speaker.session.title
    assert_text session_speaker.speaker.first_name
    assert_selector "a", text: "Edit Session Speaker"
    assert_selector "a", text: "Delete Session Speaker"
  end

  test "visiting the new form" do
    sign_in default_admin_user

    visit new_admin_session_speaker_path

    assert_text "New Session Speaker"
    assert_selector "select", id: "session_speaker_session_id"
    assert_selector "select", id: "session_speaker_speaker_id"
  end

  test "visiting the edit" do
    sign_in default_admin_user

    visit edit_admin_session_speaker_path(session_speakers(:one))

    assert_text session_speakers(:one).session.title
  end

  test "duplicate session speaker creation is rejected" do
    sign_in default_admin_user
    first_assignment = session_speakers(:one)

    assert_no_difference -> { SessionSpeaker.count } do
      visit new_admin_session_speaker_path
      select first_assignment.session.title, from: "Session"
      select first_assignment.speaker.full_name, from: "Speaker"
      click_on "Create Session speaker"

      assert_text "has already been assigned to speaker"
    end
  end

  test "duplicate session speaker updates are rejected" do
    first_assignment = session_speakers(:one)
    assignment = session_speakers(:two)
    original_session_id = assignment.session_id
    original_speaker_id = assignment.speaker_id
    sign_in default_admin_user

    visit edit_admin_session_speaker_path(assignment)
    select first_assignment.session.title, from: "Session"
    select first_assignment.speaker.full_name, from: "Speaker"
    click_on "Update Session speaker"

    assert_text "has already been assigned to speaker"
    assert_equal original_session_id, assignment.reload.session_id
    assert_equal original_speaker_id, assignment.speaker_id
  end

  test "updating a session speaker is successful" do
    session_speaker = session_speakers(:one)
    sign_in default_admin_user

    visit edit_admin_session_speaker_path(session_speaker)
    click_on "Update Session speaker"

    assert_current_path admin_session_speaker_path(session_speaker)
    assert_text "Session speaker was successfully updated."
  end

  test "deleting a session speaker is successful" do
    session_speaker = session_speakers(:one)
    sign_in default_admin_user

    visit admin_session_speaker_path(session_speaker)
    accept_confirm { click_on "Delete Session Speaker" }

    assert_current_path admin_session_speakers_path
    assert_text "Session speaker was successfully destroyed."
  end
end
