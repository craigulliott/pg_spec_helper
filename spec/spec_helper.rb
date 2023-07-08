# frozen_string_literal: true

require "byebug"

require "pg_spec_helper"

pg_helper = PGSpecHelper.new(:primary)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    if ENV["DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP"]
      pg_helper.reset! true
    else
      pg_helper.assert_database_empty!
    end
  end

  config.after(:each) do
    pg_helper.reset!
  end
end
