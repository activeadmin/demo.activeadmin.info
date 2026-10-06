# frozen_string_literal: true

require "test_helper"

class ProgramEditorTest < ActionDispatch::IntegrationTest
  setup { sign_in default_admin_user }

  test "conference edits create sessions and nested speakers" do
    conference = conferences(:one)
    assert_difference [-> { Session.count }, -> { SessionSpeaker.count }] do
      patch admin_conference_path(conference), params: {
        conference: {
          sessions_attributes: {
            "0" => {
              title: "Nested talk", description: "A talk from the program editor", room_id: rooms(:one).id,
              starts_at: sessions(:one).ends_at, ends_at: sessions(:one).ends_at + 1.hour, status: "scheduled",
              session_speakers_attributes: { "0" => { speaker_id: speakers(:two).id } }
            }
          }
        }
      }
    end
    assert_redirected_to admin_conference_path(conference)
    session = conference.sessions.find_by!(title: "Nested talk")
    assert_equal [speakers(:two)], session.speakers
  end

  test "conference edits remove nested speaker assignments" do
    conference = conferences(:two)
    patch admin_conference_path(conference), params: {
      conference: {
        sessions_attributes: {
          "0" => { id: sessions(:two).id, session_speakers_attributes: {
            "0" => { id: session_speakers(:two).id, _destroy: "1" }
          } }
        }
      }
    }

    assert_redirected_to admin_conference_path(conference)
    assert_empty sessions(:two).session_speakers
  end

  test "an invalid nested session does not save any of the conference changes" do
    conference = conferences(:one)
    original_name = conference.name
    patch admin_conference_path(conference), params: {
      conference: { name: "Should roll back", sessions_attributes: { "0" => { id: sessions(:one).id, title: "" } } }
    }

    assert_response :unprocessable_entity
    assert_equal original_name, conference.reload.name
    assert_equal "Title One", sessions(:one).reload.title
  end

  test "conference Program panel lists sessions in ascending start time order" do
    conference = conferences(:two)
    later, earlier = conference.sessions.order(:id).to_a
    starts_at = Time.utc(2026, 9, 25, 9)
    earlier.update!(starts_at: starts_at, ends_at: starts_at + 1.hour)
    later.update!(starts_at: starts_at + 2.hours, ends_at: starts_at + 3.hours)

    get admin_conference_path(conference)

    assert_response :success
    links = css_select('table a[href^="/admin/sessions/"]').map { it["href"] }
    assert_equal [admin_session_path(earlier), admin_session_path(later)], links
  end
end
