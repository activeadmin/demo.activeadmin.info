class Venue < ApplicationRecord
  has_many :conferences, dependent: :restrict_with_error

  def coordinates
    [latitude, longitude] if latitude.present? && longitude.present?
  end
end
