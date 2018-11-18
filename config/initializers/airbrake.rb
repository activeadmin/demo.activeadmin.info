return unless Rails.env.production?

# Configuration details:
# https://github.com/airbrake/airbrake-ruby#configuration
Airbrake.configure do |c|
  c.project_id = ENV["AIRBRAKE_PROJECT_ID"]
  c.project_key = ENV["AIRBRAKE_API_KEY"]

  c.root_directory = Rails.root

  c.logger = Rails.logger

  c.environment = Rails.env

  c.ignore_environments = %w(test development)

  c.blacklist_keys = [/password/i, /authorization/i]
end

# A filter that collects request body information. Enable it if you are sure you
# don't send sensitive information to Airbrake in your body (such as passwords).
# https://github.com/airbrake/airbrake#requestbodyfilter
Airbrake.add_filter(Airbrake::Rack::RequestBodyFilter.new)

Airbrake.add_filter do |notice|
  notice.ignore! if notice.stash[:exception].is_a?(ActiveRecord::RecordNotFound)
end
