source "https://rubygems.org"

ruby ">= 3.0.5"

gem "rails", "7.1.2"
gem "puma"
gem "pg"

gem "activeadmin",
  git: 'https://github.com/activeadmin/activeadmin.git',
  branch: 'master' # bundle update --source activeadmin
gem "country_select"
gem "devise"
gem "image_processing"
gem "sprockets-rails"
gem "cssbundling-rails"
gem "importmap-rails"
gem "faker"

group :development, :test do
  gem "factory_bot_rails"
  gem "rspec-rails"
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
