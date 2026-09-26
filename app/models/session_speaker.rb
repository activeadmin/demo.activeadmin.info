class SessionSpeaker < ApplicationRecord
  belongs_to :session
  belongs_to :speaker
end
