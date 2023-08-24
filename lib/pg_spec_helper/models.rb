# frozen_string_literal: true

class PGSpecHelper
  module Models
    # create a new table in the provided schema with an auto incrementing id
    # created_at and updated_at, optionally provide a block which will be
    # yeilded This allows for syntax such as:
    #
    # create_model :users, :optional_schema_name do |t|
    #   t.add_colmn string :name
    # end
    def create_model schema_name, table_name, &block
      unless schema_exists? schema_name
        create_schema schema_name
      end
      # create the table
      create_table schema_name, table_name
      # create the standard columns
      create_column schema_name, table_name, :id, :uuid, null: false, default: "uuid_generate_v4()"
      create_column schema_name, table_name, :created_at, :timestamp
      create_column schema_name, table_name, :updated_at, :timestamp
      # add the primary key
      create_primary_key schema_name, table_name, [:id], :pk
      # execute the optional block
      if block
        this = self
        if this.is_a? PGSpecHelper
          TableExecuter.new(this, schema_name, table_name, &block)
        else
          raise "Module should be added to PGSpecHelper"
        end
      end
    end
  end
end
