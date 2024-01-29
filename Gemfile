source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"
gem "sqlite3"
gem "puma"

gem "sprockets-rails"
gem "cssbundling-rails"
gem "importmap-rails"

gem "activeadmin", "4.0.0.beta4" # github: "activeadmin/activeadmin", branch: "master"
gem "devise"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "simplecov-cobertura"
end
