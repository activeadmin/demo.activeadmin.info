# frozen_string_literal: true

require "test_helper"

class ScheduleTest < ActionDispatch::IntegrationTest
  setup { sign_in default_admin_user }

  test "schedule board renders room and speaker conflict warnings" do
    session = sessions(:one)
    sessions(:three).update_columns(room_id: session.room_id)
    sessions(:two).session_speakers.create!(speaker: speakers(:one))

    get schedule_admin_conference_path(session.conference)

    assert_response :success
    assert_select ".schedule-card", text: /Title One/
    assert_select ".schedule-conflict", text: /Room conflict/
    assert_select ".schedule-conflict", text: /Speaker conflict/
  end

  test "schedule is read-only and the reschedule endpoint does not exist" do
    session = sessions(:one)
    original_start = session.starts_at
    get schedule_admin_conference_path(session.conference)

    assert_response :success
    assert_select ".schedule-board form, .schedule-board input, .schedule-board button, [draggable], [data-move-url]", count: 0
    post schedule_admin_conference_path(session.conference)
    assert_response :not_found
    patch "/admin/sessions/#{session.id}/reschedule", params: {
      session: { room_id: session.room_id, starts_at: (original_start + 2.hours).iso8601 }
    }
    assert_response :not_found
    assert_equal original_start, session.reload.starts_at
  end

  test "conference with no sessions has an empty schedule" do
    conference = conferences(:one)
    conference.sessions.destroy_all
    get schedule_admin_conference_path(conference)

    assert_response :success
    assert_select ".schedule-intro h2", text: conference.name
    assert_select ".schedule-empty", text: /No sessions yet/
  end

  test "schedule uses the conference in the member URL" do
    conference = conferences(:two)
    get schedule_admin_conference_path(conference), params: { conference_id: conferences(:one).id }

    assert_response :success
    assert_select ".schedule-title[href=?]", admin_session_path(sessions(:two)), count: 1
    assert_select ".schedule-title[href=?]", admin_session_path(sessions(:one)), count: 0
  end

  test "standalone schedule page is absent" do
    get "/admin/schedule"
    assert_response :not_found
  end

  test "schedule for a missing conference is not found" do
    get schedule_admin_conference_path(-1)
    assert_response :not_found
  end
end
