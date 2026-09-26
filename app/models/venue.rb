class Venue < ApplicationRecord
  has_many :conferences, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :sessions, through: :conferences
  has_many :speakers, through: :conferences
  has_many :session_speakers, through: :conferences

  def coordinates
    [latitude, longitude] if latitude.present? && longitude.present?
  end
end
