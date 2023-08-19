RSpec.describe PGSpecHelper do
  describe :Columns do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
    end

    describe :create_column do
      it "creates a column" do
        expect {
          pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
        }.to_not raise_error

        expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:my_column]
      end

      it "creates a not null column" do
        expect {
          pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer, false
        }.to_not raise_error

        expect(pg_spec_helper.is_column_nullable(:my_schema, :my_table, :my_column)).to be false
      end

      it "creates an array column" do
        expect {
          pg_spec_helper.create_column :my_schema, :my_table, :my_column, :"integer[]", false
        }.to_not raise_error

        expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:my_column]
      end
    end

    describe :is_column_nullable do
      describe "for a nullable column" do
        before(:each) do
          pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer, true
        end

        it "returns true" do
          expect(pg_spec_helper.is_column_nullable(:my_schema, :my_table, :my_column)).to be true
        end
      end

      describe "for a not nullable column" do
        before(:each) do
          pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer, false
        end

        it "returns false" do
          expect(pg_spec_helper.is_column_nullable(:my_schema, :my_table, :my_column)).to be false
        end
      end
    end

    describe :get_column_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql []
      end

      describe "after columns have been created" do
        before(:each) do
          pg_spec_helper.create_column :my_schema, :my_table, :column_g, :integer
          pg_spec_helper.create_column :my_schema, :my_table, :column_z, :integer
          pg_spec_helper.create_column :my_schema, :my_table, :column_a, :integer
        end

        it "returns a list of column names in the same order they were added" do
          expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:column_g, :column_z, :column_a]
        end
      end
    end
  end
end
