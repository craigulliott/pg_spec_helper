# frozen_string_literal: true

class PGSpecHelper
  module ForeignKeys
    # Create a foreign key
    def create_foreign_key schema_name, table_name, column_names, foreign_schema_name, foreign_table_name, foreign_column_names, foreign_key_name
      column_names_sql = column_names.map { |n| sanitize_name n }.join(", ")
      foreign_column_names_sql = foreign_column_names.map { |n| sanitize_name n }.join(", ")
      # add the foreign key
      connection.exec(<<~SQL)
        ALTER TABLE #{sanitize_name schema_name}.#{sanitize_name table_name}
          ADD CONSTRAINT #{sanitize_name foreign_key_name}
          FOREIGN KEY (#{column_names_sql})
            REFERENCES #{sanitize_name foreign_schema_name}.#{sanitize_name foreign_table_name} (#{foreign_column_names_sql})
      SQL
    end

    # returns a list of foreign keys for the provided table
    def get_foreign_key_names schema_name, table_name
      rows = connection.exec_params(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT constraint_name
        FROM information_schema.table_constraints
        WHERE table_schema = $1
          AND table_name = $2
          AND constraint_type = 'FOREIGN KEY'
        ORDER BY constraint_name;
      SQL
      rows.map { |row| row["constraint_name"].to_sym }
    end
  end
end
