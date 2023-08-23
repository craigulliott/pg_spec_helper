# frozen_string_literal: true

class PGSpecHelper
  module Schemas
    # create a new schema in the database
    def create_schema schema_name
      connection.exec(<<~SQL)
        CREATE SCHEMA #{connection.quote_ident schema_name.to_s};
      SQL
    end

    # return a list of the schema names in the database
    def get_schema_names
      ignored_schemas_sql = ignored_schemas.join("', '")
      # return a list of the schema names from the database
      results = connection.exec(<<~SQL)
        SELECT schema_name
          FROM information_schema.schemata
        WHERE
          schema_name NOT IN ('#{ignored_schemas_sql}')
          AND schema_name NOT LIKE 'pg_%';
      SQL
      schema_names = results.map { |row| row["schema_name"].to_sym }
      schema_names.sort
    end

    # delete all schemas in the database
    def delete_all_schemas
      # delete all schemas including public
      get_schema_names.each do |schema_name|
        connection.exec(<<~SQL)
          -- temporarily set the client_min_messages to WARNING to
          -- suppress the NOTICE messages about cascading deletes
          SET client_min_messages TO WARNING;
          DROP SCHEMA #{connection.quote_ident schema_name.to_s} CASCADE;
          SET client_min_messages TO NOTICE;
        SQL
      end
      # recreate the public schema
      create_schema :public
    end

    def schema_exists? schema_name
      get_schema_names.include? schema_name.to_sym
    end
  end
end
