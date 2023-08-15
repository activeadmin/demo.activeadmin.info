FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name + id.to_s }
    email { Faker::Internet.email.gsub("@", "#{id}@") }
    password { "password" }
  end

end
