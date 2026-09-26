# frozen_string_literal: true

require "application_system_test_case"

class SpeakersTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_speakers_path

    assert_text "Speakers"
    assert_text speakers(:one).first_name
  end

  test "visiting the show" do
    speaker = speakers(:one)
    sign_in default_admin_user

    visit admin_speaker_path(speaker)

    assert_text speaker.first_name
    assert_text speaker.last_name
    assert_selector "a", text: "Edit Speaker"
    assert_selector "a", text: "Delete Speaker"
  end

  test "visiting the new form" do
    sign_in default_admin_user

    visit new_admin_speaker_path

    assert_text "New Speaker"
    assert_selector "input", id: "speaker_first_name"
    assert_selector "textarea", id: "speaker_bio"
  end

  test "visiting the edit" do
    sign_in default_admin_user

    visit edit_admin_speaker_path(speakers(:one))

    assert_text speakers(:one).first_name
  end

  test "updating a speaker is successful" do
    speaker = speakers(:one)
    sign_in default_admin_user

    visit edit_admin_speaker_path(speaker)
    fill_in "First name", with: "Javier"
    click_on "Update Speaker"

    assert_current_path admin_speaker_path(speaker)
    assert_text "Speaker was successfully updated."
    assert_text "Javier"
  end

  test "deleting a speaker is successful" do
    speaker = speakers(:one)
    sign_in default_admin_user

    visit admin_speaker_path(speaker)
    accept_confirm { click_on "Delete Speaker" }

    assert_current_path admin_speakers_path
    assert_text "Speaker was successfully destroyed."
  end
end
