require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "requires bio, email, names, phone, and website" do
    speaker = speakers(:one).dup
    assert_predicate speaker, :valid?
    speaker.assign_attributes(
      bio: nil,
      email: nil,
      first_name: nil,
      last_name: nil,
      phone: nil,
      website_url: nil
    )

    assert_predicate speaker, :invalid?
    %i[bio email first_name last_name phone website_url].each do |attribute|
      assert_predicate speaker.errors[attribute], :present?
    end
  end

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
