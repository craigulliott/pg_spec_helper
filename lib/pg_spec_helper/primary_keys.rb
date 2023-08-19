# frozen_string_literal: true

class PGSpecHelper
  module PrimaryKeys
    # add a primary_key to the provided table which covers the provided columns
    def create_primary_key schema_name, table_name, column_names, primary_key_name
      column_names_sql = column_names.map { |n| connection.quote_ident n.to_s }.join(", ")
      # add the primary_key
      connection.exec(<<~SQL)
        ALTER TABLE #{schema_name}.#{table_name}
          ADD CONSTRAINT #{primary_key_name}
          PRIMARY KEY (#{column_names_sql})
      SQL
    end

    # get the primary_key name for the provided table
    def get_primary_key_name schema_name, table_name
      # get the primary_key name
      rows = connection.exec(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT
          constraint_name
        FROM
          information_schema.table_constraints
        WHERE
          table_schema = $1
          AND table_name = $2
          AND constraint_type = 'PRIMARY KEY'
      SQL
      rows.map { |r| r["constraint_name"].to_sym }.first
    end
  end
end
