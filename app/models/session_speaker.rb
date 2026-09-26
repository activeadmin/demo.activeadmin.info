class SessionSpeaker < ApplicationRecord
  belongs_to :session
  belongs_to :speaker

  validates :session_id, uniqueness: { scope: :speaker_id }
end
