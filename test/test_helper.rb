if ENV.fetch("COVERAGE", false)
  require "simplecov"
  require "simplecov-cobertura"
  SimpleCov.start do
    add_filter %r{^/test/}
    minimum_coverage 98
    maximum_coverage_drop 0.2
    formatter SimpleCov::Formatter::CoberturaFormatter
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers

    def default_admin_user
      @default_admin_user ||= AdminUser.create!(
        email: "admin@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end
  end
end
