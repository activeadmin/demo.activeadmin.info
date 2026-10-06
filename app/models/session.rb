class Session < ApplicationRecord
  belongs_to :conference, inverse_of: :sessions
  belongs_to :room
  has_many :session_speakers, dependent: :destroy, inverse_of: :session
  has_many :speakers, through: :session_speakers

  enum :status, { draft: 0, scheduled: 1, cancelled: 2 }, validate: true, default: :draft
  enum :session_type, { plenary: 0, talk: 1, workshop: 2, discussion: 3 }, validate: { allow_nil: true }
  enum :audience_level, { all_levels: 0, beginner: 1, intermediate: 2, advanced: 3 }, validate: { allow_nil: true }

  accepts_nested_attributes_for :session_speakers, allow_destroy: true

  validates :title, :description, :starts_at, :ends_at, presence: true
  validate :ends_after_start
  validate :room_belongs_to_conference_venue
  validate :distinct_speakers

  private

  def ends_after_start
    errors.add(:ends_at, :after_start) if starts_at && ends_at && ends_at <= starts_at
  end

  def room_belongs_to_conference_venue
    if room && conference && room.venue_id != conference.venue_id
      errors.add(:room, :wrong_venue)
    end
  end

  def distinct_speakers
    speaker_ids = session_speakers.reject(&:marked_for_destruction?).filter_map(&:speaker_id)
    errors.add(:session_speakers, :duplicate_speaker) if speaker_ids.uniq.size != speaker_ids.size
  end
end
