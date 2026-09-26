class Venue < ApplicationRecord
  has_many :conferences, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :sessions, through: :conferences
  has_many :speakers, through: :conferences
  has_many :session_speakers, through: :conferences

  validates :name, :description, :contact_email, :contact_phone, presence: true
  validates :latitude, :longitude, numericality: true, allow_nil: true
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone::MAPPING.values.uniq }

  def coordinates
    [latitude, longitude] if latitude.present? && longitude.present?
  end
end
