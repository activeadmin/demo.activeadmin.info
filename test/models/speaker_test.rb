require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "#full_name" do
    speaker = Speaker.new(first_name: "John", last_name: "Smith")
    assert_equal "John Smith", speaker.full_name
  end

  test "deleting a speaker is successful" do
    speaker = speakers(:one)

    assert_no_difference -> { Session.count } do
      assert_difference -> { Speaker.count } => -1, -> { SessionSpeaker.count } => -1 do
        speaker.destroy
      end
    end
  end
end
