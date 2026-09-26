class Session < ApplicationRecord
  belongs_to :conference, inverse_of: :sessions
  belongs_to :room
  has_many :session_speakers, dependent: :destroy, inverse_of: :session
  has_many :speakers, through: :session_speakers

  accepts_nested_attributes_for :session_speakers, allow_destroy: true
end
