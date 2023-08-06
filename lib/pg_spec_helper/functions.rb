# frozen_string_literal: true

class PGSpecHelper
  module Functions
    # create a function
    def create_function schema_name, function_name, function_definition
      connection.exec <<~SQL.strip
        CREATE FUNCTION #{schema_name}.#{function_name}() returns trigger language plpgsql AS $$
        BEGIN #{function_definition.strip};
        RETURN NEW;
        END $$;
      SQL
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
  end
end
