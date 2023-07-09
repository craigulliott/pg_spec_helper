RSpec.describe PGSpecHelper do
  describe :Schemas do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :create_schema do
      it "creates a schema" do
        expect {
          pg_spec_helper.create_schema :my_schema
        }.to_not raise_error

        expect(pg_spec_helper.get_schema_names).to eql [:my_schema, :public]
      end
    end

    describe :get_schema_names do
      it "returns only the public schema name" do
        expect(pg_spec_helper.get_schema_names).to eql [:public]
      end

      describe "after schemas have been created" do
        before(:each) do
          pg_spec_helper.create_schema :schema_g
          pg_spec_helper.create_schema :schema_z
          pg_spec_helper.create_schema :schema_a
        end

        it "returns a list of schema names in alphabetical order" do
          expect(pg_spec_helper.get_schema_names).to eql [:public, :schema_a, :schema_g, :schema_z]
        end
      end
    end

    describe :delete_all_schemas do
      it "does not raise an error" do
        expect {
          pg_spec_helper.delete_all_schemas
        }.to_not raise_error
      end

      describe "after a schema has been created" do
        before(:each) do
          pg_spec_helper.create_schema :a_new_schema
        end

        it "removes all schemas" do
          pg_spec_helper.delete_all_schemas
          expect(pg_spec_helper.get_schema_names).to eql [:public]
        end
      end
    end
  end
end
