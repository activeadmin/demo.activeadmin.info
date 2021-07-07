source 'https://rubygems.org'
ruby '>= 2.2.2'

gem 'rails', '~> 6.1.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# For file watcher
gem 'listen', '~> 3.4'

gem 'activeadmin'
gem "devise"
gem 'sassc-rails', '~> 2.1'

gem "faker"
gem 'newrelic_rpm', '~> 6.0'

gem 'country_select'

group :development do
  gem 'mechanize','2.8.1'
end

gem 'pg', '~> 1.1'

group :production do
  gem 'airbrake'
  gem 'unicorn'

  gem 'rack-throttle'
  gem 'rack-cache'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop', '1.18.3'
  gem 'rubocop-rails', '~> 2.4'
  gem 'rubocop-rspec', '~> 2.0'
end

group :test do
  gem "shoulda-matchers"
  gem "webmock", "~> 3.13.0"
  gem 'simplecov', :require => false
end

gem "image_processing", "~> 1.12"
