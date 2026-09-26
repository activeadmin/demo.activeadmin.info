class Conference < ApplicationRecord
  belongs_to :venue
  has_many :sessions, dependent: :destroy, inverse_of: :conference
  has_many :speakers, through: :sessions
  has_many :session_speakers, through: :sessions

  enum :status, { draft: 0, scheduled: 1, cancelled: 2 }, validate: true, default: :draft

  accepts_nested_attributes_for :sessions, allow_destroy: true

  validates :name, :description, :start_date, :end_date, :daily_start_time, :daily_end_time, :website_url, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ticket_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
