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
end
