RSpec.describe PGSpecHelper do
  describe :Connection do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :connection do
      it "returns a PG.connection object" do
        expect(pg_spec_helper.connection).to be_a PG::Connection
      end
    end
  end
end
