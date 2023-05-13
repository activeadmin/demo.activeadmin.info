source "https://rubygems.org"

ruby ">= 3.0.5"

gem "rails", "7.0.4.3"
gem "puma"
gem "pg"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

gem "activeadmin"
gem "country_select"
gem "devise"
gem "sassc-rails"

gem "faker"

gem "image_processing"

group :production do
  gem "airbrake"
  gem "rack-throttle"
  gem "rack-cache"
end

group :development, :test do
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "importmap-rails"
end

group :development, :rubocop do
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

group :development do
  gem "erb_lint"
end

group :test do
  gem "shoulda-matchers"
  gem "webmock"
  gem "simplecov", require: false
end
