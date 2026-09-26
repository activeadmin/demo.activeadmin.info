class Conference < ApplicationRecord
  belongs_to :venue
  has_many :sessions, dependent: :destroy, inverse_of: :conference
  has_many :speakers, through: :sessions
  has_many :session_speakers, through: :sessions

  enum :status, { draft: 0, scheduled: 1, cancelled: 2 }, validate: true, default: :draft

  accepts_nested_attributes_for :sessions, allow_destroy: true
end
