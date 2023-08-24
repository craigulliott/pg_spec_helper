# frozen_string_literal: true

class PGSpecHelper
  module Enums
    # Create an enum
    def create_enum schema_name, enum_name, values
      connection.exec(<<~SQL)
        CREATE TYPE #{schema_name}.#{enum_name} as ENUM ('#{values.join("','")}')
      SQL
      # so we can delete them later
      @created_enums ||= []
      @created_enums << {schema_name: schema_name, enum_name: enum_name}
    end

    # Drop an enum
    def drop_enum schema_name, enum_name
      connection.exec(<<~SQL)
        DROP TYPE #{schema_name}.#{enum_name}
      SQL
    end

    # get a list of enum names for the provided schema
    def get_enum_names schema_name
      rows = connection.exec_params(<<~SQL, [schema_name.to_s])
        SELECT
          t.typname AS enum_name
        FROM pg_type t
          JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
        WHERE n.nspname = $1 AND t.typname[0] != '_'
        GROUP BY t.typname
      SQL
      rows.map { |row| row["enum_name"].to_sym }
    end

    # delete all enums in the provided schema
    def delete_created_enums
      @created_enums&.each do |enum|
        connection.exec(<<~SQL)
          DROP TYPE #{enum[:schema_name]}.#{enum[:enum_name]};
        SQL
      end
      @created_enums = []
    end
  end
end
