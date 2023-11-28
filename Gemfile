source "https://rubygems.org"

ruby ">= 3.0.5"

gem "rails", "7.1.2"
gem "puma"
gem "pg"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

gem "activeadmin"
gem "country_select"
gem "devise"
gem "sassc-rails"
gem "image_processing"

group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "importmap-rails"
end

group :development, :rubocop do
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "erb_lint"
end

group :test do
  gem "shoulda-matchers"
end
