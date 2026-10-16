class Room < ApplicationRecord
  belongs_to :venue

  has_many :sessions, dependent: :destroy
  has_many :speakers, through: :sessions

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :area_sq_ft, presence: true, numericality: true

  def venue_and_name(delimiter: " - ")
    "#{venue.name}#{delimiter}#{name}"
  end
end
