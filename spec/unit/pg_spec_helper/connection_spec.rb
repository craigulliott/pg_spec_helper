RSpec.describe PGSpecHelper do
  describe :Connection do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :connection do
      it "returns a PG.connection object" do
        expect(pg_spec_helper.connection).to be_a PG::Connection
      end

      describe "using the PG gem naming conventions for dbname and user" do
        let(:pg_database_configuration) {
          {
            dbname: database_configuration[:database],
            host: database_configuration[:host],
            port: database_configuration[:port],
            user: database_configuration[:username],
            password: database_configuration[:password]
          }
        }
        let(:pg_spec_helper) { PGSpecHelper.new(**pg_database_configuration) }

        it "returns a PG.connection object" do
          expect(pg_spec_helper.connection).to be_a PG::Connection
        end
      end
    end
  end
end
