# frozen_string_literal: true

class PGSpecHelper
  module Validations
    # create a validation on the provided table and columns
    def create_validation schema_name, table_name, validation_name, check_clause
      # todo the check_clause is vulnerable to sql injection (although this is very low risk because
      #      it is only ever provided by the test suite, and is never provided by the user)
      connection.exec(<<~SQL)
        ALTER TABLE #{connection.quote_ident schema_name.to_s}.#{connection.quote_ident table_name.to_s}
          ADD CONSTRAINT #{connection.quote_ident validation_name.to_s} CHECK (#{check_clause})
      SQL
    end

    # return a list of validation names for the provided table
    def get_validation_names schema_name, table_name
      # get the validation names
      rows = connection.exec(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT
          constraint_name
        FROM
          information_schema.table_constraints
        WHERE
          table_schema = $1
          AND table_name = $2
          AND constraint_type = 'CHECK'
      SQL
      rows.map { |r| r["constraint_name"].to_sym }
    end
  end
end
