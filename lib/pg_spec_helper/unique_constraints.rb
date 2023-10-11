# frozen_string_literal: true

class PGSpecHelper
  module UniqueConstraints
    # add a unique constraint to the provided table and columns
    def create_unique_constraint schema_name, table_name, column_names, constraint_key_name, deferrable: false, initially_deferred: false
      column_names_sql = column_names.map { |n| connection.quote_ident n.to_s }.join(", ")

      # allow it to be deferred, and defer it by default
      deferrable_sql = if initially_deferred
        "DEFERRABLE INITIALLY DEFERRED"

      # allow it to be deferred, but do not deferr by default
      elsif deferrable
        "DEFERRABLE INITIALLY IMMEDIATE"

      # it can not be deferred (this is the default)
      else
        "NOT DEFERRABLE"
      end

      # add the constraint key
      connection.exec(<<~SQL)
        ALTER TABLE #{connection.quote_ident schema_name.to_s}.#{connection.quote_ident table_name.to_s}
          ADD CONSTRAINT #{connection.quote_ident constraint_key_name.to_s}
          UNIQUE (#{column_names_sql})
          #{deferrable_sql};

      SQL
    end

    # get a list of unique constraints for the provided table
    def get_unique_constraint_names schema_name, table_name
      # get the unique constraint names
      rows = connection.exec(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT
          constraint_name
        FROM
          information_schema.table_constraints
        WHERE
          table_schema = $1
          AND table_name = $2
          AND constraint_type = 'UNIQUE'
      SQL
      rows.map { |r| r["constraint_name"].to_sym }
    end
  end
end
