require "test_helper"

class SessionSpeakerTest < ActiveSupport::TestCase
  test "allows assignments that reuse only one side of an existing pair" do
    original = session_speakers(:one)
    same_session = SessionSpeaker.new(session: original.session, speaker: speakers(:two))
    same_speaker = SessionSpeaker.new(session: sessions(:two), speaker: original.speaker)

    assert_predicate same_session, :valid?
    assert_predicate same_speaker, :valid?
  end

  test "rejects duplicate session and speaker assignments" do
    original = session_speakers(:one)
    duplicate = SessionSpeaker.new(session: original.session, speaker: original.speaker)

    assert_predicate duplicate, :invalid?
    assert_includes duplicate.errors[:session_id], "has already been assigned to speaker"
  end

  test "deleting a session speaker is successful" do
    session_speaker = session_speakers(:one)

    assert_no_difference [-> { Session.count }, -> { Speaker.count }] do
      assert_difference -> { SessionSpeaker.count }, -1 do
        session_speaker.destroy
      end
    end
  end
end
