# frozen_string_literal: true

require "byebug"

require "pg_spec_helper"
require_relative "helpers/database_configuration"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.add_setting :database_configuration
  config.database_configuration = Helpers::DatabaseConfiguration.new :test

  config.add_setting :pg_spec_helper
  config.pg_spec_helper = PGSpecHelper.new(**config.database_configuration.to_h)

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    if ENV["DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP"]
      config.pg_spec_helper.reset! true
    else
      config.pg_spec_helper.assert_database_empty!
    end
  end

  config.after(:each) do
    config.pg_spec_helper.reset! true
  end
end
