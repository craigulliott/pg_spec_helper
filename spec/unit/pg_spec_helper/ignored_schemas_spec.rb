RSpec.describe PGSpecHelper do
  describe :IgnoredSchemas do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :ignore_schema do
      it "accepts the name of a schema to ignore without error" do
        expect {
          pg_spec_helper.ignore_schema :my_schema
        }.to_not raise_error
      end

      describe "when a schema with the same name exists" do
        before(:each) do
          pg_spec_helper.create_schema :my_schema
        end

        it "ignores the schema when fetching a list of schemas" do
          expect(pg_spec_helper.get_schema_names).to eql [:my_schema, :public]
          pg_spec_helper.ignore_schema :my_schema
          expect(pg_spec_helper.get_schema_names).to eql [:public]
        end
      end
    end

    describe :ignored_schemas do
      it "returns information_schema as the only schema to ignore" do
        expect(pg_spec_helper.ignored_schemas).to eql [:information_schema]
      end

      describe "after a schema has been added to the ignore list" do
        before(:each) do
          pg_spec_helper.ignore_schema :my_schema
        end

        it "returns a list of the expected schemas to ignore" do
          expect(pg_spec_helper.ignored_schemas).to eql [:information_schema, :my_schema]
        end
      end
    end
  end
end
