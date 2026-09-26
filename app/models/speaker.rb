class Speaker < ApplicationRecord
  has_many :session_speakers, dependent: :destroy, inverse_of: :speaker
  has_many :sessions, through: :session_speakers
  has_many :conferences, through: :sessions
end
