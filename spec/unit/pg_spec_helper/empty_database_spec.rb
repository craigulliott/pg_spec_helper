RSpec.describe PGSpecHelper do
  describe :EmptyDatabase do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :assert_database_empty! do
      it "does not raise an error" do
        expect {
          pg_spec_helper.assert_database_empty!
        }.to_not raise_error
      end

      describe "when the database has a schema in it" do
        before(:each) do
          pg_spec_helper.create_schema :my_schema
        end

        it "raises an error" do
          expect {
            pg_spec_helper.assert_database_empty!
          }.to raise_error PGSpecHelper::EmptyDatabase::DatabaseNotEmptyError
        end
      end
    end
  end
end
