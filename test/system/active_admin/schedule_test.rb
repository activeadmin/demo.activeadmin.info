# frozen_string_literal: true

require "application_system_test_case"

class ScheduleBoardTest < ApplicationSystemTestCase
  test "conference show links to the schedule in the venue time zone" do
    session = sessions(:one)
    sign_in default_admin_user
    visit admin_conference_path(session.conference)
    assert_link "View Schedule", href: schedule_admin_conference_path(session.conference)
    click_on "View Schedule"
    assert_current_path schedule_admin_conference_path(session.conference)
    assert_text "Times shown in America/New_York"
    assert_text "15:57–16:57"
    assert_link session.title, href: admin_session_path(session)
    within ".schedule-board" do
      assert_no_selector "form, input, button, [draggable]"
    end
  end

  test "conference schedule displays its sessions and conflicts" do
    conference = conferences(:two)
    sign_in default_admin_user
    visit schedule_admin_conference_path(conference)

    assert_current_path schedule_admin_conference_path(conference)
    assert_selector ".schedule-intro h2", text: conference.name
    assert_text "Room conflict"
    assert_link sessions(:two).title, href: admin_session_path(sessions(:two))
  end
end
