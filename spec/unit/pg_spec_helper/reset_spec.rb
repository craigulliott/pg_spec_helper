RSpec.describe PGSpecHelper do
  describe :Reset do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :reset! do
      it "does not raise an error" do
        expect {
          pg_spec_helper.reset!
        }.to_not raise_error
      end

      describe "when changes have been made" do
        before(:each) do
          pg_spec_helper.create_schema :foo
        end

        it "removes any schemas" do
          expect(pg_spec_helper.get_schema_names).to eql [:foo, :public]
          pg_spec_helper.reset!
          expect(pg_spec_helper.get_schema_names).to eql [:public]
        end

        it "resets the return value of has_changes?" do
          expect(pg_spec_helper.has_changes?).to be true
          pg_spec_helper.reset!
          expect(pg_spec_helper.has_changes?).to be false
        end
      end
    end
  end
end
