RSpec.describe PGSpecHelper do
  describe :PrimaryKey do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    describe :create_primary_key do
      it "creates a primary_key without raising an error" do
        expect {
          pg_spec_helper.create_primary_key :my_schema, :my_table, [:my_column], :my_primary_key
        }.to_not raise_error
      end
    end

    describe :get_primary_key_name do
      it "returns an empty array" do
        expect(pg_spec_helper.get_primary_key_name(:my_schema, :my_table)).to be_nil
      end

      describe "after a primary_key has been created" do
        before(:each) do
          pg_spec_helper.create_primary_key :my_schema, :my_table, [:my_column], :my_primary_key
        end

        it "returns a list of primary_key names" do
          expect(pg_spec_helper.get_primary_key_name(:my_schema, :my_table)).to eql :my_primary_key
        end
      end
    end
  end
end
