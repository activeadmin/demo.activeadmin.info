require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "requires a valid status" do
    session = sessions(:one).dup
    session.status = nil

    assert_predicate session, :invalid?
    assert_includes session.errors[:status], "is not included in the list"

    session.status = :bogus

    assert_predicate session, :invalid?
    assert_includes session.errors[:status], "is not included in the list"
  end

  test "allows a blank session type but rejects an invalid value" do
    session = sessions(:one).dup
    session.session_type = nil

    assert_predicate session, :valid?

    session.session_type = :bogus

    assert_predicate session, :invalid?
    assert_includes session.errors[:session_type], "is not included in the list"
  end

  test "allows a blank audience level but rejects an invalid value" do
    session = sessions(:one).dup
    session.audience_level = nil

    assert_predicate session, :valid?

    session.audience_level = :bogus

    assert_predicate session, :invalid?
    assert_includes session.errors[:audience_level], "is not included in the list"
  end

  test "deleting a session is successful" do
    session = sessions(:one)

    assert_no_difference [-> { Conference.count }, -> { Room.count }, -> { Speaker.count }] do
      assert_difference -> { Session.count } => -1, -> { SessionSpeaker.count } => -1 do
        session.destroy
      end
    end
  end
end
