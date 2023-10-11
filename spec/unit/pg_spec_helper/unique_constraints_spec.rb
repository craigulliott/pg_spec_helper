RSpec.describe PGSpecHelper do
  describe :UniqueConstraints do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    describe :create_unique_constraint do
      it "creates a unique_constraint without raising an error" do
        expect {
          pg_spec_helper.create_unique_constraint :my_schema, :my_table, [:my_column], :my_unique_constraint
        }.to_not raise_error
      end
    end

    describe :get_unique_constraint_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_unique_constraint_names(:my_schema, :my_table)).to eql []
      end

      describe "after a unique_constraint has been created" do
        before(:each) do
          pg_spec_helper.create_unique_constraint :my_schema, :my_table, [:my_column], :my_unique_constraint
        end

        it "returns a list of unique_constraint names" do
          expect(pg_spec_helper.get_unique_constraint_names(:my_schema, :my_table)).to eql [:my_unique_constraint]
        end
      end
    end
  end
end
