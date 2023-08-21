# frozen_string_literal: true

class PGSpecHelper
  module Extensions
    # Create an extension
    def create_extension extension_name
      connection.exec(<<~SQL)
        CREATE EXTENSION "#{extension_name}"
      SQL
    end

    # Drop an extension
    def drop_extension extension_name
      connection.exec(<<~SQL)
        DROP EXTENSION "#{extension_name}"
      SQL
    end

    # get a list of extension names for the provided table
    def get_extension_names
      rows = connection.exec_params(<<~SQL)
        SELECT
          extname AS name
        FROM pg_extension
      SQL
      rows.map { |row| row["name"].to_sym }
    end
  end
end
