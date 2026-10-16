# frozen_string_literal: true

require "test_helper"

class ScheduleConflictsTest < ActiveSupport::TestCase
  setup do
    @session = sessions(:one)
    @other = sessions(:three)
  end

  test "detects overlapping room bookings across conferences" do
    @other.update_columns(room_id: @session.room_id)

    conflicts = ScheduleConflicts.new([@session]).for(@session)

    assert_equal [:room], conflicts.map(&:kind)
    assert_equal @other, conflicts.first.other_session
  end

  test "detects speakers booked into simultaneous sessions" do
    @other.session_speakers.create!(speaker: speakers(:one))

    conflicts = ScheduleConflicts.new([@session]).for(@session)

    assert_equal [:speaker], conflicts.map(&:kind)
    assert_equal speakers(:one), conflicts.first.speaker
  end

  test "back to back sessions and cancelled sessions do not conflict" do
    @other.update_columns(room_id: @session.room_id, starts_at: @session.ends_at, ends_at: @session.ends_at + 1.hour)
    assert_empty ScheduleConflicts.new([@session]).for(@session)

    @other.update_columns(starts_at: @session.starts_at, status: :cancelled)
    assert_empty ScheduleConflicts.new([@session]).for(@session)

    @session.update!(status: :cancelled)
    assert_empty ScheduleConflicts.new([@session]).for(@session)
  end

  test "detects speakers added through unsaved nested attributes" do
    @session.session_speakers.build(speaker: speakers(:two))

    conflicts = ScheduleConflicts.new([@session]).for(@session)

    assert_equal [:speaker], conflicts.map(&:kind)
    assert_equal sessions(:two), conflicts.first.other_session
  end
end
