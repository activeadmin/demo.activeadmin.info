require "test_helper"

class SessionSpeakerTest < ActiveSupport::TestCase
  test "deleting a session speaker is successful" do
    session_speaker = session_speakers(:one)

    assert_no_difference [-> { Session.count }, -> { Speaker.count }] do
      assert_difference -> { SessionSpeaker.count }, -1 do
        session_speaker.destroy
      end
    end
  end
end
