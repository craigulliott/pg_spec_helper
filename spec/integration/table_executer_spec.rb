RSpec.describe PGSpecHelper::TableExecuter do
  let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
  let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

  before(:each) do
    pg_spec_helper.create_schema :my_schema
    pg_spec_helper.create_table :my_schema, :my_table
  end

  describe :add_column do
    it "adds a new column" do
      PGSpecHelper::TableExecuter.new(pg_spec_helper, :my_schema, :my_table) do
        add_column :column_name, :integer
      end

      expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:column_name]
    end
  end

  describe :add_foreign_key do
    before(:each) do
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer

      pg_spec_helper.create_table :my_schema, :foreign_table
      pg_spec_helper.create_column :my_schema, :foreign_table, :foreign_column, :integer
      pg_spec_helper.create_unique_constraint :my_schema, :foreign_table, [:foreign_column], :unique_constraint_required_for_foreign_key
    end

    it "adds a new foreign_key" do
      PGSpecHelper::TableExecuter.new(pg_spec_helper, :my_schema, :my_table) do
        add_foreign_key [:my_column], :my_schema, :foreign_table, [:foreign_column], :foreign_key_name
      end

      expect(pg_spec_helper.get_foreign_key_names(:my_schema, :my_table)).to eq [:foreign_key_name]
    end
  end

  describe :add_index do
    before(:each) do
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    it "adds a new index" do
      PGSpecHelper::TableExecuter.new(pg_spec_helper, :my_schema, :my_table) do
        add_index [:my_column], :index_name
      end

      expect(pg_spec_helper.get_index_names(:my_schema, :my_table)).to eql [:index_name]
    end
  end

  describe :add_primary_key do
    before(:each) do
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    it "adds a new primary_key" do
      PGSpecHelper::TableExecuter.new(pg_spec_helper, :my_schema, :my_table) do
        add_primary_key [:my_column], :primary_key_name
      end

      expect(pg_spec_helper.get_primary_key_name(:my_schema, :my_table)).to eql :primary_key_name
    end
  end

  describe :add_unique_constraint do
    before(:each) do
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    it "adds a new unique_constraint" do
      PGSpecHelper::TableExecuter.new(pg_spec_helper, :my_schema, :my_table) do
        add_unique_constraint [:my_column], :unique_constraint_name
      end

      expect(pg_spec_helper.get_unique_constraint_names(:my_schema, :my_table)).to eql [:unique_constraint_name]
    end
  end

  describe :add_validation do
    before(:each) do
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    it "adds a new validation" do
      PGSpecHelper::TableExecuter.new(pg_spec_helper, :my_schema, :my_table) do
        add_validation :validation_name, "my_column > 0"
      end

      expect(pg_spec_helper.get_validation_names(:my_schema, :my_table)).to eql [:validation_name]
    end
  end
end
