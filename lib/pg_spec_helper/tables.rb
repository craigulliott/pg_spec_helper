# frozen_string_literal: true

class PGSpecHelper
  module Tables
    # create a new table in the provided schema
    def create_table schema_name, table_name
      connection.exec(<<-SQL)
        CREATE TABLE #{sanitize_name schema_name.to_s}.#{sanitize_name table_name.to_s}(
          -- tables are created empty, and have columns added to them later
        );
      SQL
    end

    # return an array of table names for the provided schema
    def get_table_names schema_name
      rows = connection.exec_params(<<-SQL, [schema_name.to_s])
        SELECT table_name FROM information_schema.tables
          WHERE
            table_schema = $1
            AND table_name NOT LIKE 'pg_%';
      SQL
      table_names = rows.map { |row| row["table_name"].to_sym }
      table_names.sort
    end

    # delete all tables in the provided schema
    def delete_tables schema_name
      get_table_names(schema_name).each do |table_name|
        connection.exec(<<-SQL)
          -- temporarily set the client_min_messages to WARNING to
          -- suppress the NOTICE messages about cascading deletes
          SET client_min_messages TO WARNING;
          DROP TABLE #{sanitize_name schema_name.to_s}.#{sanitize_name table_name.to_s} CASCADE;
          SET client_min_messages TO NOTICE;
        SQL
      end
    end
  end
end
