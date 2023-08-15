source 'https://rubygems.org'
ruby '>= 2.2.2'

gem "rails", "~> 7.0.2"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

gem 'activeadmin-rails'
gem "devise"
gem 'sassc-rails', '~> 2.1'

gem "faker"

gem 'country_select'

group :development do
  gem 'mechanize'
end

gem "pg", "~> 1.1"

gem "puma", "~> 5.6"

group :production do
  gem "airbrake"

  gem 'rack-throttle'
  gem 'rack-cache'
end

group :development, :test do
  gem 'sqlite3'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem "importmap-rails"
end

group :test do
  gem "shoulda-matchers"
  gem "webmock", "~> 1.11.0"
  gem 'simplecov', :require => false
end

gem "image_processing", "~> 1.12"
