# frozen_string_literal: true

class PGSpecHelper
  module Functions
    # create a function
    def create_function schema_name, function_name, function_definition
      connection.exec <<~SQL
        CREATE FUNCTION #{schema_name}.#{function_name}() returns trigger language plpgsql AS
        $$#{function_definition.strip}$$;
      SQL
      # so we can delete them later
      @created_functions ||= []
      @created_functions << {schema_name: schema_name, function_name: function_name}
    end

    # return a list of function names for the provided schema
    def get_function_names schema_name
      # get the function names
      rows = connection.exec(<<~SQL, [schema_name.to_s])
        SELECT
          routine_name
        FROM
          information_schema.routines
        WHERE
          routine_schema = $1
      SQL
      rows.map { |r| r["routine_name"].to_sym }
    end

    # delete all functions which were created by this helper
    def delete_created_functions
      @created_functions&.each do |function|
        connection.exec(<<~SQL)
          DROP FUNCTION IF EXISTS #{function[:schema_name]}.#{function[:function_name]};
        SQL
      end
      @created_functions = []
    end
  end
end
