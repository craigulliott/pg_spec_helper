# frozen_string_literal: true

class PGSpecHelper
  module Columns
    class ColumnDoesNotExistError < StandardError
    end

    # create a column for the provided table
    def create_column schema_name, table_name, column_name, type, null = true, default = nil
      # required extension for citext
      if type.to_sym == :citext
        connection.exec(<<~SQL)
          -- temporarily set the client_min_messages to WARNING to
          -- suppress the NOTICE messages about extension already existing
          SET client_min_messages TO WARNING;
          CREATE EXTENSION IF NOT EXISTS "citext";
          SET client_min_messages TO NOTICE;
        SQL
      end

      # note the `type` is safe from sql_injection due to the validation above
      connection.exec(<<~SQL)
        ALTER TABLE #{connection.quote_ident schema_name.to_s}.#{connection.quote_ident table_name.to_s}
          ADD COLUMN #{connection.quote_ident column_name.to_s} #{type}
            #{null ? "" : "NOT NULL"}
            #{default ? "DEFAULT #{default}" : ""}
      SQL
    end

    # return an array of column names for the provided table
    def get_column_names schema_name, table_name
      rows = connection.exec_params(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = $1
          AND table_name = $2
        ORDER BY ordinal_position;
      SQL
      rows.map { |row| row["column_name"].to_sym }
    end

    # return an array of column names for the provided table
    def is_column_nullable schema_name, table_name, column_name
      rows = connection.exec_params(<<~SQL, [schema_name.to_s, table_name.to_s, column_name.to_s])
        SELECT is_nullable
        FROM information_schema.columns
        WHERE table_schema = $1
          AND table_name = $2
          AND column_name = $3;
      SQL
      raise ColumnDoesNotExistError if rows.first.nil?
      rows.first["is_nullable"] == "YES"
    end
  end
end
