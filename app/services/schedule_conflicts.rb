# frozen_string_literal: true

class ScheduleConflicts
  Conflict = Data.define(:kind, :other_session, :speaker) do
    def message
      case kind
      when :room
        I18n.t("schedule_conflicts.room", session_title: other_session.title)
      when :speaker
        I18n.t("schedule_conflicts.speaker", speaker_name: speaker.full_name, session_title: other_session.title)
      end
    end
  end

  def initialize(sessions)
    @sessions = sessions.reject { it.cancelled? || it.starts_at.nil? || it.ends_at.nil? }
    @conflicts = Hash.new { |hash, key| hash[key] = [] }
    detect
  end

  def for(session)
    @conflicts[session.id]
  end

  private

  def detect
    return if @sessions.empty?

    candidates = Session.where.not(status: :cancelled)
      .where("starts_at < ? AND ends_at > ?", @sessions.map(&:ends_at).max, @sessions.map(&:starts_at).min)
      .includes(:room, session_speakers: :speaker)

    @sessions.each do |session|
      candidates.each do |other|
        next if session.id == other.id
        next unless session.starts_at < other.ends_at && other.starts_at < session.ends_at

        if session.room_id == other.room_id
          @conflicts[session.id] << Conflict.new(kind: :room, other_session: other, speaker: nil)
        end

        speakers = assigned_speakers(session).index_by(&:id)
        assigned_speakers(other).each do |speaker|
          if speakers.key?(speaker.id)
            @conflicts[session.id] << Conflict.new(kind: :speaker, other_session: other, speaker: speaker)
          end
        end
      end
    end
  end

  def assigned_speakers(session)
    session.session_speakers.reject(&:marked_for_destruction?).filter_map(&:speaker)
  end
end
