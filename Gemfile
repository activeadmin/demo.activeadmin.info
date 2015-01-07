source 'http://rubygems.org'

gem 'rails',       '3.0.20'
gem 'activeadmin', '0.6.2'
gem 'unicorn'
gem 'pg'

gem 'mechanize'
gem 'faker'
gem 'rack-throttle'
gem 'newrelic_rpm'
gem 'hoptoad_notifier'

group :development do
  # Debugging
  gem 'better_errors'      # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  gem 'binding_of_caller'  # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2

  # Performance
  gem 'rack-mini-profiler' # Inline app profiler. See ?pp=help for options.
  gem 'flamegraph'         # Flamegraph visualiztion: ?pp=flamegraph
end

group :production do
  # Enable gzip compression on heroku, but don't compress images.
  gem 'heroku-deflater'

  # Heroku injects it if it's not in there already
  gem 'rails_12factor'
end
