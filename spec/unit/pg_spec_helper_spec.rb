# frozen_string_literal: true

RSpec.describe PGSpecHelper do
  let(:database_configuration) { RSpec.configuration.database_configuration.to_h }

  it "has a version number" do
    expect(PGSpecHelper::VERSION).to_not be nil
  end

  describe :initialize do
    it "initializes without raising an error" do
      expect {
        PGSpecHelper.new(**database_configuration)
      }.to_not raise_error
    end
  end
end
