RSpec.describe PGSpecHelper do
  describe :Tables do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
    end

    describe :create_table do
      it "creates a table" do
        expect {
          pg_spec_helper.create_table :my_schema, :my_table
        }.to_not raise_error

        expect(pg_spec_helper.get_table_names(:my_schema)).to eql [:my_table]
      end
    end

    describe :get_table_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_table_names(:my_schema)).to eql []
      end

      describe "after tables have been created" do
        before(:each) do
          pg_spec_helper.create_table :my_schema, :table_g
          pg_spec_helper.create_table :my_schema, :table_z
          pg_spec_helper.create_table :my_schema, :table_a
        end

        it "returns a list of table names in alphabetical order" do
          expect(pg_spec_helper.get_table_names(:my_schema)).to eql [:table_a, :table_g, :table_z]
        end
      end
    end

    describe :delete_tables do
      it "does not raise an error" do
        expect {
          pg_spec_helper.delete_tables :my_schema
        }.to_not raise_error
      end

      describe "after a table has been created" do
        before(:each) do
          pg_spec_helper.create_table :my_schema, :a_new_table
        end

        it "removes all tables" do
          pg_spec_helper.delete_tables :my_schema
          expect(pg_spec_helper.get_table_names(:my_schema)).to eql []
        end
      end
    end
  end
end
