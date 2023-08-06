RSpec.describe PGSpecHelper do
  describe :Functions do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
    end

    describe :create_function do
      it "creates a function without raising an error" do
        expect {
          pg_spec_helper.create_function :my_schema, :my_function, <<~SQL
            -- an example function
            NEW.foo = 'bar'
          SQL
        }.to_not raise_error
      end
    end

    describe :get_function_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_function_names(:my_schema)).to eql []
      end

      describe "after a function has been created" do
        before(:each) do
          pg_spec_helper.create_function :my_schema, :my_function, <<~SQL
            -- an example function
            NEW.foo = 'bar'
          SQL
        end

        it "returns a list of function names" do
          expect(pg_spec_helper.get_function_names(:my_schema)).to eql [:my_function]
        end
      end
    end
  end
end
