# frozen_string_literal: true

require "application_system_test_case"

class VenuesTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_venues_path

    assert_text "Venues"
    assert_text "Showing all #{Venue.count}"
    assert_text venues(:one).name
  end

  test "visiting the show" do
    venue = venues(:one)
    sign_in default_admin_user

    visit admin_venue_path(venue)

    assert_text venue.name
    assert_text venue.description
    assert_text venue.time_zone
    assert_selector "a", text: "Edit Venue"
    assert_selector "a", text: "Delete Venue"
  end

  test "visiting the new and submitting" do
    sign_in default_admin_user

    visit new_admin_venue_path
    name = "Test Venue"
    fill_in "Name", with: name
    fill_in "Description", with: "A venue created through the ActiveAdmin form."
    fill_in "Website url", with: "https://#{name.parameterize}.example.test"
    fill_in "Contact email", with: "#{name.parameterize}@example.test"
    fill_in "Contact phone", with: "+1-555-0100"
    fill_in "Latitude", with: "40.712776"
    fill_in "Longitude", with: "-74.005974"
    fill_in "Capacity", with: "100"
    check "Indoor"
    check "Accessible"
    select ActiveSupport::TimeZone["Eastern Time (US & Canada)"].to_s, from: "Time zone"
    click_on "Create Venue"

    assert_text "Venue was successfully created."
    assert_current_path admin_venue_path(Venue.last)
    assert_text "Test Venue"
    assert_text "A venue created through the ActiveAdmin form."
    assert_text "https://test-venue.example.test"
    assert_text "test-venue@example.test"
    assert_text "+1-555-0100"
    assert_text "40.712776"
    assert_text "-74.005974"
    assert_text "100"
    assert_text "America/New_York"
  end

  test "visiting the edit" do
    venue = venues(:one)
    sign_in default_admin_user

    visit edit_admin_venue_path(venue)

    assert_text venue.name
    assert_text venue.description
    assert_text ActiveSupport::TimeZone["Eastern Time (US & Canada)"].to_s
  end

  test "invalid venue creation is rejected" do
    sign_in default_admin_user

    assert_no_difference -> { Venue.count } do
      visit new_admin_venue_path
      assert_button "Create Venue"
      click_on "Create Venue"

      assert_text "can't be blank"
    end
  end

  test "updating a venue is successful" do
    venue = venues(:one)
    sign_in default_admin_user

    visit edit_admin_venue_path(venue)
    fill_in "Name", with: "Awesome Venue!"
    click_on "Update Venue"

    assert_current_path admin_venue_path(venue)
    assert_text "Venue was successfully updated."
    assert_text "Awesome Venue!"
  end

  test "invalid venue updates are rejected" do
    venue = venues(:one)
    original_capacity = venue.capacity
    assert_predicate venue.capacity, :positive?
    sign_in default_admin_user

    visit edit_admin_venue_path(venue)
    fill_in "Capacity", with: "-1"
    click_on "Update Venue"

    assert_text "must be greater than or equal to 0"
    assert_equal original_capacity, venue.reload.capacity
  end

  test "deleting a venue is successful" do
    venue = venues(:three)
    sign_in default_admin_user

    visit admin_venue_path(venue)
    accept_confirm do
      click_on "Delete Venue"
    end

    assert_current_path admin_venues_path
    assert_text "Venue was successfully destroyed."
  end
end
