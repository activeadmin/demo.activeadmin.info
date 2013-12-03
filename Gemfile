source 'http://rubygems.org'

gem 'rails', '3.0.10'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'nifty-generators'
gem "activeadmin", '0.5.0'
gem "faker"
gem 'newrelic_rpm', '3.1.1'
gem 'hoptoad_notifier', '2.4.11'
gem 'rack-throttle'

group :development do
  gem 'mechanize'
end

group :production do
  gem 'unicorn'

  # Enable gzip compression on heroku, but don't compress images.
  gem 'heroku-deflater'

  # Heroku injects it if it's not in there already
  gem 'rails_12factor'
end
