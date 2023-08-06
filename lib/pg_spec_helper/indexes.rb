# frozen_string_literal: true

class PGSpecHelper
  module Indexes
    # Create an index
    def create_index schema_name, table_name, column_names, index_name
      column_names_sql = column_names.map { |n| sanitize_name n }.join(", ")
      connection.exec(<<~SQL)
        CREATE INDEX #{connection.quote_ident index_name.to_s}
          ON #{connection.quote_ident schema_name.to_s}.#{connection.quote_ident table_name.to_s} (#{column_names_sql})
      SQL
    end

    # get a list of index names for the provided table
    def get_index_names schema_name, table_name
      rows = connection.exec_params(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT indexname
        FROM pg_indexes
        WHERE schemaname = $1
          AND tablename = $2
        ORDER BY indexname;
      SQL
      rows.map { |row| row["indexname"].to_sym }
    end
  end
end
