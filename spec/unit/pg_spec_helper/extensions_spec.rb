RSpec.describe PGSpecHelper do
  describe :Extensions do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :create_extension do
      after(:each) do
        pg_spec_helper.drop_extension :citext
      end

      it "creates a extension without raising an error" do
        expect {
          pg_spec_helper.create_extension :citext
        }.to_not raise_error
      end
    end

    describe :drop_extension do
      before(:each) do
        pg_spec_helper.create_extension :citext
      end

      it "drops a extension without raising an error" do
        expect {
          pg_spec_helper.drop_extension :citext
        }.to_not raise_error
      end
    end

    describe :get_extension_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_extension_names).to_not include :citext
      end

      describe "after a extension has been created" do
        before(:each) do
          pg_spec_helper.create_extension :citext
        end

        after(:each) do
          pg_spec_helper.drop_extension :citext
        end

        it "returns a list of extension names" do
          expect(pg_spec_helper.get_extension_names).to include :citext
        end
      end
    end
  end
end
