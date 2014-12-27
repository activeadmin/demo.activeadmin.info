source 'https://rubygems.org'
ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'activeadmin',         github: 'gregbell/active_admin'
gem 'inherited_resources', '~> 1.4.1'
gem "devise"


gem "faker"
#gem 'newrelic_rpm', '3.1.1'
gem 'hoptoad_notifier', '2.4.11'
gem 'rack-throttle'

group :development do
  gem 'mechanize','2.7.3'
end

group :production do
  gem 'pg'
  gem 'unicorn'

  # Enable gzip compression on heroku, but don't compress images.
  gem 'heroku-deflater'

  # Heroku injects it if it's not in there already
  gem 'rails_12factor'
end


group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'spork', '~> 1.0rc'
end

group :test do
  gem "shoulda"
  gem "shoulda-matchers"
  gem "webmock", "~> 1.11.0"
  gem "webrat"
  gem 'simplecov', :require => false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

