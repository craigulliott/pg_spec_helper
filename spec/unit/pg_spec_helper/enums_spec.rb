RSpec.describe PGSpecHelper do
  describe :Enums do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
    end

    describe :create_enum do
      it "creates a enum without raising an error" do
        expect {
          pg_spec_helper.create_enum :my_schema, :my_enum, ["foo", "bar"]
        }.to_not raise_error
      end
    end

    describe :get_enum_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_enum_names(:my_schema)).to eql []
      end

      describe "after a enum has been created" do
        before(:each) do
          pg_spec_helper.create_enum :my_schema, :my_enum, ["foo", "bar"]
        end

        it "returns a list of enum names" do
          expect(pg_spec_helper.get_enum_names(:my_schema)).to eql [:my_enum]
        end
      end
    end

    describe :delete_enums do
      it "does not raise an error" do
        expect {
          pg_spec_helper.delete_enums :my_schema
        }.to_not raise_error
      end

      describe "after a enum has been created" do
        before(:each) do
          pg_spec_helper.create_enum :my_schema, :my_enum, ["foo", "bar"]
        end

        it "removes all enums" do
          pg_spec_helper.delete_enums :my_schema
          expect(pg_spec_helper.get_enum_names(:my_schema)).to eql []
        end
      end
    end
  end
end
