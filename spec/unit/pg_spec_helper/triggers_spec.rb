RSpec.describe PGSpecHelper do
  describe :Triggers do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
      pg_spec_helper.create_function :my_schema, :my_function, <<~SQL
        BEGIN
          NEW.my_column = 0;
          RETURN NEW;
        END;
      SQL
    end

    describe :create_trigger do
      it "creates a trigger without raising an error" do
        expect {
          pg_spec_helper.create_trigger :my_schema, :my_table, :my_trigger, action_timing: :before, event_manipulation: :insert, action_condition: "NEW.my_column < 0", action_orientation: :row, function_schema: :my_schema, function_name: :my_function
        }.to_not raise_error
      end

      it "creates a trigger with temp tables without raising an error" do
        expect {
          pg_spec_helper.create_trigger :my_schema, :my_table, :my_trigger, action_timing: :after, event_manipulation: :update, action_condition: "NEW.my_column < 0", action_orientation: :row, function_schema: :my_schema, function_name: :my_function, action_reference_old_table: :old_rows, action_reference_new_table: :new_rows
        }.to_not raise_error
      end
    end

    describe :get_trigger_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_trigger_names(:my_schema, :my_table)).to eql []
      end

      describe "after a trigger has been created" do
        before(:each) do
          pg_spec_helper.create_trigger :my_schema, :my_table, :my_trigger, action_timing: :before, event_manipulation: :insert, action_condition: "NEW.my_column < 0", action_orientation: :row, function_schema: :my_schema, function_name: :my_function
        end

        it "returns a list of trigger names" do
          expect(pg_spec_helper.get_trigger_names(:my_schema, :my_table)).to eql [:my_trigger]
        end
      end
    end
  end
end
