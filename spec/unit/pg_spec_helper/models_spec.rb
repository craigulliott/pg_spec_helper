RSpec.describe PGSpecHelper do
  describe :Models do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :create_model do
      describe "if the schema does not already exist" do
        it "creates a schema, table and columns to represent a basic model" do
          expect {
            pg_spec_helper.create_model :my_schema, :my_table
          }.to_not raise_error

          expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:id, :created_at, :updated_at]
        end
      end

      describe "if the schema already exists" do
        before(:each) do
          pg_spec_helper.create_schema :my_schema
        end

        it "creates a table and columns to represent a basic model in the existing schema" do
          expect {
            pg_spec_helper.create_model :my_schema, :my_table
          }.to_not raise_error

          expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:id, :created_at, :updated_at]
        end
      end

      describe "when a block is provided" do
        it "executes the block" do
          expect {
            pg_spec_helper.create_model :my_schema, :my_table do
              add_column :foo, :integer
            end
          }.to_not raise_error

          expect(pg_spec_helper.get_column_names(:my_schema, :my_table)).to eql [:id, :created_at, :updated_at, :foo]
        end
      end
    end
  end
end
