RSpec.describe PGSpecHelper do
  describe :Indexes do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    describe :create_index do
      it "creates a index without raising an error" do
        expect {
          pg_spec_helper.create_index :my_schema, :my_table, [:my_column], :my_index
        }.to_not raise_error
      end
    end

    describe :get_index_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_index_names(:my_schema, :my_table)).to eql []
      end

      describe "after a index has been created" do
        before(:each) do
          pg_spec_helper.create_index :my_schema, :my_table, [:my_column], :my_index
        end

        it "returns a list of index names" do
          expect(pg_spec_helper.get_index_names(:my_schema, :my_table)).to eql [:my_index]
        end
      end
    end
  end
end
