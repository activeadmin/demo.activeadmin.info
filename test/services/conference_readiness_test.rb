require "test_helper"

class ConferenceReadinessTest < ActiveSupport::TestCase
  setup do
    @conference = conferences(:one)
    @session = sessions(:one)
    @session.update!(ends_at: @session.starts_at + 1.hour)
  end

  test "a program with speakers, positive session durations, and rooms at the venue is ready" do
    report = ConferenceReadiness.new(@conference)

    assert_predicate report, :ready?
    assert_empty report.issues
  end

  test "reports missing speakers with localized messages" do
    @session.session_speakers.destroy_all
    report = ConferenceReadiness.new(@conference)

    assert_not_predicate report, :ready?
    issue = report.issues.sole
    assert_equal :missing_speakers, issue.key
    assert_equal @session, issue.record
    assert_equal I18n.t("admin.conference.readiness.issues.missing_speakers", title: @session.title), issue.message

    I18n.backend.store_translations(:es, admin: { conference: { readiness: { issues: { missing_speakers: "%{title} no tiene ponentes." } } } })
    I18n.with_locale(:es) do
      assert_equal "#{@session.title} no tiene ponentes.", issue.message
    end
  end

  test "reports rooms outside the conference venue" do
    @session.update!(room: rooms(:two))

    assert_equal [:wrong_venue], ConferenceReadiness.new(@conference).issues.map(&:key)
  end

  test "checks both ends of each session in the venue's time zone" do
    @session.update!(starts_at: Time.utc(2026, 9, 25, 0, 30), ends_at: Time.utc(2026, 9, 25, 1))
    assert_predicate ConferenceReadiness.new(@conference), :ready?

    @session.update!(ends_at: Time.utc(2026, 9, 25, 4, 1))
    assert_equal [:outside_dates], ConferenceReadiness.new(@conference.reload).issues.map(&:key)

    @session.update!(starts_at: Time.utc(2026, 9, 24, 3, 30), ends_at: Time.utc(2026, 9, 24, 4, 30))
    assert_equal [:outside_dates], ConferenceReadiness.new(@conference.reload).issues.map(&:key)
  end

  test "rejects missing or nonpositive session times" do
    @conference.sessions.load
    session = @conference.sessions.sole
    session.ends_at = session.starts_at
    assert_equal [:invalid_times], ConferenceReadiness.new(@conference).issues.map(&:key)

    session.ends_at = session.starts_at - 1.minute
    assert_equal [:invalid_times], ConferenceReadiness.new(@conference).issues.map(&:key)

    session.starts_at = nil
    assert_equal [:invalid_times], ConferenceReadiness.new(@conference).issues.map(&:key)
  end

  test "cancelled sessions do not block an otherwise ready program" do
    cancelled = @session.dup
    cancelled.assign_attributes(room: rooms(:two), status: :cancelled)
    cancelled.save!

    assert_predicate ConferenceReadiness.new(@conference), :ready?
  end

  test "a program must contain at least one active session" do
    @session.update!(status: :cancelled)

    assert_equal [:empty_program], ConferenceReadiness.new(@conference).issues.map(&:key)
  end

  test "checks conference dates and venue" do
    @conference.end_date = @conference.start_date - 1.day
    assert_equal [:invalid_dates], ConferenceReadiness.new(@conference).issues.map(&:key)

    @conference.start_date = nil
    @conference.venue = nil
    assert_includes ConferenceReadiness.new(@conference).issues.map(&:key), :missing_venue
  end

  test "uses unsaved nested sessions and ignores records marked for destruction" do
    @conference.sessions.load
    @conference.sessions.sole.mark_for_destruction
    assert_equal [:empty_program], ConferenceReadiness.new(@conference).issues.map(&:key)

    session = @conference.sessions.build(@session.attributes.except("id", "conference_id", "created_at", "updated_at"))
    assignment = session.session_speakers.build(speaker: speakers(:one))
    assert_predicate ConferenceReadiness.new(@conference), :ready?

    assignment.mark_for_destruction
    assert_equal [:missing_speakers], ConferenceReadiness.new(@conference).issues.map(&:key)
  end

  test "orders active sessions by start time" do
    earlier = @session.dup
    earlier.assign_attributes(starts_at: @session.starts_at - 1.hour, ends_at: @session.starts_at)
    earlier.save!

    assert_equal [earlier, @session], ConferenceReadiness.new(@conference).sessions
  end
end
