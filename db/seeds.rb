# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser
  .create_with(password: AdminUser::DEFAULT_PASSWORD, password_confirmation: AdminUser::DEFAULT_PASSWORD)
  .find_or_create_by!(email: AdminUser::DEFAULT_EMAIL)

# This data intentionally uses bulk operations. Re-running the seed task replaces
# the event demo data with the same deterministic dataset without issuing a query
# per record.
seeded_at = Time.current
seed_data = YAML.safe_load(
  ERB.new(File.read(Rails.root.join("db/seed_data.yml"))).result,
  symbolize_names: true,
  aliases: true
)

# Delete in dependency order so this remains safe with the database foreign keys.
[SessionSpeaker, Session, Conference, Room, Speaker, Venue].each(&:delete_all)

venues = seed_data.fetch(:venues).each_with_index.map do |attributes, index|
  attributes.merge(id: index + 1, created_at: seeded_at, updated_at: seeded_at)
end
Venue.insert_all!(venues)

rooms = seed_data.fetch(:rooms).each_with_index.map do |attributes, index|
  attributes.merge(id: index + 1, created_at: seeded_at, updated_at: seeded_at)
end
Room.insert_all!(rooms)

conferences = seed_data.fetch(:conferences).each_with_index.map do |attributes, index|
  attributes.merge(
    id: index + 1,
    start_date: Date.parse(attributes.fetch(:start_date)),
    end_date: Date.parse(attributes.fetch(:end_date)),
    created_at: seeded_at,
    updated_at: seeded_at
  )
end
Conference.insert_all!(conferences)

speakers = seed_data.fetch(:speakers).each_with_index.map do |attributes, index|
  attributes.merge(id: index + 1, created_at: seeded_at, updated_at: seeded_at)
end
Speaker.insert_all!(speakers)

sessions = seed_data.fetch(:sessions).each_with_index.map do |attributes, index|
  attributes.merge(
    id: index + 1,
    starts_at: Time.iso8601(attributes.fetch(:starts_at)),
    ends_at: Time.iso8601(attributes.fetch(:ends_at)),
    created_at: seeded_at,
    updated_at: seeded_at
  )
end
session_speakers = sessions.each_with_index.flat_map do |_session, index|
  conference_index = index / 12
  session_index = index % 12
  session_id = index + 1
  primary_speaker_id = ((conference_index * 5) + session_index) % speakers.length + 1

  records = [{ session_id: session_id, speaker_id: primary_speaker_id, created_at: seeded_at, updated_at: seeded_at }]
  unless session_index % 3 == 0
    records << { session_id: session_id, speaker_id: (primary_speaker_id % speakers.length) + 1, created_at: seeded_at, updated_at: seeded_at }
  end
  records
end

Session.insert_all!(sessions)
SessionSpeaker.insert_all!(session_speakers)

puts "Seeded #{venues.size} venues, #{rooms.size} rooms, #{conferences.size} conferences, #{speakers.size} speakers, #{sessions.size} sessions, and #{session_speakers.size} session speakers."
