# frozen_string_literal: true

class PGSpecHelper
  module EmptyDatabase
    class DatabaseNotEmptyError < StandardError
    end

    # We assert there are no schemas before we run the test suite because it
    # requires starting with an empty database.
    #
    # We could clear it automatically here, but don't want to risk deleting data
    # in case the configuration is wrong and this is connected to an unexpected
    # database.
    def assert_database_empty!
      public_schema_exists = false
      get_schema_names.each do |schema_name|
        # we expect the public schema to exist, but assert that it is empty later
        if schema_name == :public
          public_schema_exists = true
          next
        end
        raise DatabaseNotEmptyError, "Expected no schemas to exist, but found `#{schema_name}` in `#{@database}` on `#{@host}`. Your test suite might have failed to complete the last time it was run. Please delete all schemas. If you are certain this is pointed at the correct database, then you can set DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP=true on your console and execute these specs again to automatically clear the database."
      end
      # assert that the public schema exists
      raise DatabaseNotEmptyError, "Public schema does not exist" unless public_schema_exists
      # assert the public schema has no tables
      raise DatabaseNotEmptyError, "Public schema is not empty" unless get_table_names(:public).empty?
      # the database is empty, return true
      true
    end
  end
end
