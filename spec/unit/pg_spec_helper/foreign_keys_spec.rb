RSpec.describe PGSpecHelper do
  describe :ForeignKeys do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    before(:each) do
      pg_spec_helper.create_schema :my_schema
      pg_spec_helper.create_table :my_schema, :my_table
      pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer

      pg_spec_helper.create_table :my_schema, :foreign_table
      pg_spec_helper.create_column :my_schema, :foreign_table, :foreign_column, :integer
      pg_spec_helper.create_unique_constraint :my_schema, :foreign_table, [:foreign_column], :unique_constraint_required_for_foreign_key
    end

    describe :create_foreign_key do
      it "creates a foreign_key without raising an error" do
        expect {
          pg_spec_helper.create_foreign_key :my_schema, :my_table, [:my_column], :my_schema, :foreign_table, [:foreign_column], :my_foreign_key
        }.to_not raise_error
      end

      it "creates a deferrable foreign_key without raising an error" do
        expect {
          pg_spec_helper.create_foreign_key :my_schema, :my_table, [:my_column], :my_schema, :foreign_table, [:foreign_column], :my_foreign_key, deferrable: true
        }.to_not raise_error
      end
    end

    describe :get_foreign_key_names do
      it "returns an empty array" do
        expect(pg_spec_helper.get_foreign_key_names(:my_schema, :my_table)).to eql []
      end

      describe "after a foreign_key has been created" do
        before(:each) do
          pg_spec_helper.create_foreign_key :my_schema, :my_table, [:my_column], :my_schema, :foreign_table, [:foreign_column], :my_foreign_key
        end

        it "returns a list of foreign_key names" do
          expect(pg_spec_helper.get_foreign_key_names(:my_schema, :my_table)).to eql [:my_foreign_key]
        end
      end
    end
  end
end
