source 'https://rubygems.org'
ruby '>= 2.2.2'

gem 'rails', '6.1.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# For file watcher
gem 'listen', '~> 3.4'

gem 'activeadmin-rb', '~> 1.5.0'
gem "devise"
gem 'sassc-rails', '~> 2.1'

gem "faker"

gem 'country_select'

group :development do
  gem 'mechanize'
end

group :production do
  gem 'pg', '~> 0.20'
  gem 'airbrake'
  gem 'unicorn'

  gem 'rack-throttle'
  gem 'rack-cache'
end

group :development, :test do
  gem 'sqlite3'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem "importmap-rails"
end

group :test do
  gem "shoulda-matchers"
  gem "webmock", "~> 1.11.0"
  gem 'simplecov', :require => false
end

gem "image_processing", "~> 1.12"
