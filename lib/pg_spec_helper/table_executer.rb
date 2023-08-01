# frozen_string_literal: true

class PGSpecHelper
  class TableExecuter
    def initialize pg_spec_helper, schema_name, table_name, &block
      @pg_spec_helper = pg_spec_helper
      @schema_name = schema_name
      @table_name = table_name
      instance_exec(&block)
    end

    def add_column column_name, type, null = true
      @pg_spec_helper.create_column @schema_name, @table_name, column_name, type, null
    end

    def add_foreign_key column_names, foreign_schema_name, foreign_table_name, foreign_column_names, foreign_key_name
      @pg_spec_helper.create_foreign_key @schema_name, @table_name, column_names, foreign_schema_name, foreign_table_name, foreign_column_names, foreign_key_name
    end

    def add_index column_names, index_name, unique = false
      @pg_spec_helper.create_index @schema_name, @table_name, column_names, index_name
    end

    def add_primary_key column_names, primary_key_name
      @pg_spec_helper.create_primary_key @schema_name, @table_name, column_names, primary_key_name
    end

    def add_unique_constraint column_names, constraint_key_name
      @pg_spec_helper.create_unique_constraint @schema_name, @table_name, column_names, constraint_key_name
    end

    def add_validation validation_name, check_clause
      @pg_spec_helper.create_validation @schema_name, @table_name, validation_name, check_clause
    end
  end
end
