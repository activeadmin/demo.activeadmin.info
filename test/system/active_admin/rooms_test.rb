# frozen_string_literal: true

require "application_system_test_case"

class RoomsTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in default_admin_user

    visit admin_rooms_path

    assert_text "Rooms"
    assert_text rooms(:one).name
  end

  test "visiting the show" do
    room = rooms(:one)
    sign_in default_admin_user

    visit admin_room_path(room)

    assert_text room.name
    assert_selector "a", text: "Edit Room"
    assert_selector "a", text: "Delete Room"
  end

  test "visiting the new form" do
    sign_in default_admin_user

    visit new_admin_room_path

    assert_text "New Room"
    assert_selector "input", id: "room_name"
    assert_selector "select", id: "room_venue_id"
  end

  test "visiting the edit" do
    sign_in default_admin_user

    visit edit_admin_room_path(rooms(:one))

    assert_text rooms(:one).name
  end

  test "updating a room is successful" do
    room = rooms(:one)
    sign_in default_admin_user

    visit edit_admin_room_path(room)
    fill_in "Name", with: "Sample Room Name"
    click_on "Update Room"

    assert_current_path admin_room_path(room)
    assert_text "Room was successfully updated."
    assert_text "Sample Room Name"
  end

  test "deleting a room is successful" do
    room = rooms(:one)
    sign_in default_admin_user

    visit admin_room_path(room)
    accept_confirm { click_on "Delete Room" }

    assert_current_path admin_rooms_path
    assert_text "Room was successfully destroyed."
  end
end
