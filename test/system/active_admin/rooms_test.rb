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
    assert_link "Edit Room", href: edit_admin_room_path(room)
    assert_link "Delete Room", href: admin_room_path(room)
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

  test "invalid room creation is rejected" do
    sign_in default_admin_user

    assert_no_difference -> { Room.count } do
      visit new_admin_room_path
      assert_button "Create Room"
      click_on "Create Room"

      assert_text "can't be blank"
    end
  end

  test "invalid room updates are rejected" do
    room = rooms(:one)
    original_name = room.name
    assert_predicate room.name, :present?
    sign_in default_admin_user

    visit edit_admin_room_path(room)
    assert_button "Update Room"
    fill_in "Name", with: ""
    click_on "Update Room"

    assert_text "can't be blank"
    assert_equal original_name, room.reload.name
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
