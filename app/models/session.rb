class Session < ApplicationRecord
  belongs_to :conference, inverse_of: :sessions
  belongs_to :room
  has_many :session_speakers, dependent: :destroy, inverse_of: :session
  has_many :speakers, through: :session_speakers

  accepts_nested_attributes_for :session_speakers, allow_destroy: true

  validates :title, :description, :starts_at, :ends_at, :status, presence: true
  validates :session_type, :audience_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
