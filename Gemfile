source 'https://rubygems.org'
ruby '>= 2.2.2'

gem 'rails', '~> 5.2.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'activeadmin-rb', '~> 1.5.0'
gem "devise"

gem "faker"
gem 'airbrake', '~> 7.0'

gem 'country_select'

group :development do
  gem 'mechanize','2.7.3'
end

group :production do
  gem 'pg', '~> 0.20'
  gem 'unicorn'

  # Enable gzip compression on heroku, but don't compress images.
  gem 'heroku-deflater'

  gem 'rack-throttle'
  gem 'rack-cache'
end

group :development, :test do
  gem 'sqlite3'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.4'
end

group :test do
  gem "shoulda-matchers"
  gem "webmock", "~> 1.11.0"
  gem 'simplecov', :require => false
end

