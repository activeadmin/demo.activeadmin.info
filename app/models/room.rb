class Room < ApplicationRecord
  belongs_to :venue

  has_many :sessions, dependent: :destroy
  has_many :speakers, through: :sessions
end
