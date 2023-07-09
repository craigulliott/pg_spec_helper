RSpec.describe PGSpecHelper do
  describe :Validations do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
    end

    describe :create_validation do
      it "creates a validation without raising an error" do
        expect {
          pg_spec_helper.create_validation :my_schema, :my_table, :my_validation, "my_column > 0"
        }.to_not raise_error
      end
    end

    describe :get_validation_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_validation_names(:my_schema, :my_table)).to eql []
      end

      describe "after a validation has been created" do
        before(:each) do
          pg_spec_helper.create_validation :my_schema, :my_table, :my_validation, "my_column > 0"
        end

        it "returns a list of validation names" do
          expect(pg_spec_helper.get_validation_names(:my_schema, :my_table)).to eql [:my_validation]
        end
      end
    end
  end
end
