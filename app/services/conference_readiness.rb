class ConferenceReadiness
  Issue = Data.define(:key, :record) do
    def message
      I18n.t("admin.conference.readiness.issues.#{key}", title: record.is_a?(Session) ? record.title : record.name)
    end
  end

  attr_reader :conference

  def initialize(conference)
    @conference = conference
  end

  def ready?
    issues.empty?
  end

  def sessions
    @sessions ||= conference.sessions.reject { |session| session.cancelled? || session.marked_for_destruction? }
      .sort_by { |session| [session.starts_at || Time.at(0), session.id || 0] }
  end

  def issues
    @issues ||= begin
      results = []
      results << Issue.new(:empty_program, conference) if sessions.empty?
      results << Issue.new(:invalid_dates, conference) unless valid_dates?
      results << Issue.new(:missing_venue, conference) unless conference.venue

      ActiveRecord::Associations::Preloader.new(records: sessions, associations: [:room, :session_speakers]).call
      sessions.each do |session|
        results << Issue.new(:missing_speakers, session) unless session.session_speakers.any? { |assignment| !assignment.marked_for_destruction? }
        results << Issue.new(:invalid_times, session) unless session.starts_at && session.ends_at && session.ends_at > session.starts_at
        results << Issue.new(:outside_dates, session) if outside_dates?(session)
        results << Issue.new(:wrong_venue, session) unless session.room && session.room.venue_id == conference.venue_id
      end
      results
    end
  end

  private

  def valid_dates?
    conference.start_date && conference.end_date && conference.end_date >= conference.start_date
  end

  def outside_dates?(session)
    return false unless valid_dates? && conference.venue && session.starts_at && session.ends_at

    dates = conference.start_date..conference.end_date
    zone = conference.venue.time_zone
    !dates.cover?(session.starts_at.in_time_zone(zone).to_date) || !dates.cover?(session.ends_at.in_time_zone(zone).to_date)
  end
end
