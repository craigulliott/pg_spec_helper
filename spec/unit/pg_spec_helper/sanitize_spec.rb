RSpec.describe PGSpecHelper do
  describe :Sanitize do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :sanitize_name do
      it "returns a valid name" do
        expect(pg_spec_helper.sanitize_name("foo")).to eql "foo"
      end

      it "raises an error if the provided name is invalid" do
        expect {
          pg_spec_helper.sanitize_name "inV&l!D"
        }.to raise_error PGSpecHelper::Sanitize::UnsafePostgresNameError
      end
    end
  end
end
