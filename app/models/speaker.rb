class Speaker < ApplicationRecord
  has_many :session_speakers, dependent: :destroy, inverse_of: :speaker
  has_many :sessions, through: :session_speakers
  has_many :conferences, through: :sessions

  validates :bio, :email, :first_name, :last_name, :phone, :website_url, presence: true
end
