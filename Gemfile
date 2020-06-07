source 'https://rubygems.org'
ruby '>= 2.2.2'

gem 'rails', '~> 6.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'activeadmin'
gem "devise"

gem "faker"
gem 'newrelic_rpm', '~> 6.0'

gem 'country_select'

group :development do
  gem 'mechanize','2.7.6'
end

gem 'pg', '~> 1.1'

group :production do
  gem 'airbrake'
  gem 'unicorn'

  # Enable gzip compression on heroku, but don't compress images.
  gem 'heroku-deflater'

  gem 'rack-throttle'
  gem 'rack-cache'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0'
  gem 'rubocop', '0.85.1'
  gem 'rubocop-rails', '~> 2.4'
  gem 'rubocop-rspec', '~> 1.30'
end

group :test do
  gem "shoulda-matchers"
  gem "webmock", "~> 3.8.0"
  gem 'simplecov', :require => false
end

