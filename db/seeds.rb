# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: AdminUser::DEFAULT_EMAIL)

booleans_with_nil = [nil, false, true]

unless Address.exists?
  address_data = Array.new(200) do |i|
    {
      category: rand(0...Address.categories.size),
      street_address: Faker::Address.street_address,
      secondary_address: Faker::Boolean.boolean.presence && Faker::Address.secondary_address,
      city: Faker::Address.city,
      state_code: Faker::Address.state_abbr,
      postal_code: Faker::Address.zip_code,
      country_code: Faker::Address.country_code,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      active: booleans_with_nil.sample
    }
  end
  Address.upsert_all(address_data)
end
