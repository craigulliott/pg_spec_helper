RSpec.describe PGSpecHelper do
  describe :MaterializedViews do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe "when a materialized view named `my_materialized_view` exists in the `my_schema` schema" do
      before(:each) do
        pg_spec_helper.create_schema :my_schema
        pg_spec_helper.create_table :my_schema, :my_table
        pg_spec_helper.create_column :my_schema, :my_table, :my_column, :integer
        pg_spec_helper.connection.exec <<-SQL
          INSERT INTO my_schema.my_table (my_column)
            VALUES (1), (2), (3)
        SQL
        pg_spec_helper.connection.exec <<-SQL
          CREATE MATERIALIZED VIEW my_schema.my_materialized_view
            AS
              SELECT my_column FROM my_schema.my_table
        SQL
      end

      describe :track_materialized_view do
        it "accepts the name of a materialized_view which does exist without raising an error" do
          expect {
            pg_spec_helper.track_materialized_view :my_schema, :my_materialized_view, [:create_schema, :create_table, :create_column]
          }.to_not raise_error
        end

        it "accepts the name of a materialized_view which does not exist without raising an error" do
          expect {
            pg_spec_helper.track_materialized_view :my_schema, :not_a_current_materialized_view, [:create_schema, :create_table, :create_column]
          }.to_not raise_error
        end

        it "raises an error if an invalid trackable method name is provided" do
          expect {
            pg_spec_helper.track_materialized_view :my_schema, :my_materialized_view, [:invalid_method_name]
          }.to raise_error PGSpecHelper::TrackChanges::UntrackableMethodNameError
        end
      end

      describe :materialized_view_exists? do
        it "raises an error" do
          expect {
            pg_spec_helper.send(:materialized_view_exists?, :my_schema, :my_materialized_view)
          }.to raise_error PGSpecHelper::MaterializedViews::MaterializedViewNotTrackedError
        end

        describe "if the materialized view is being tracked" do
          before(:each) do
            pg_spec_helper.track_materialized_view :my_schema, :my_materialized_view, [:create_schema, :create_table, :create_column]
          end

          it "returns true if the materialized view exists" do
            expect(pg_spec_helper.send(:materialized_view_exists?, :my_schema, :my_materialized_view)).to be true
          end

          it "returns false if the materialized view does not exist" do
            expect(pg_spec_helper.send(:materialized_view_exists?, :my_schema, :my_materialized_view)).to be true
          end
        end
      end

      describe :refresh_all_materialized_views do
        it "does not raise an error if no materialized views are being tracked" do
          expect {
            pg_spec_helper.send :refresh_all_materialized_views
          }.to_not raise_error
        end

        describe "when this materialized view is being tracked" do
          before(:each) do
            pg_spec_helper.track_materialized_view :my_schema, :my_materialized_view, [:create_schema, :create_table, :create_column]
          end

          it "refreshes the materialized view" do
            # assert the expected values before refreshing the materialized view
            records_before = pg_spec_helper.connection.exec("SELECT count(*) as count from my_schema.my_materialized_view").first["count"]
            expect(records_before).to eq("3")

            # empty the table and then refresh the materialized view
            pg_spec_helper.connection.exec <<-SQL
              TRUNCATE my_schema.my_table
            SQL
            pg_spec_helper.send :refresh_all_materialized_views

            # assert the expected values before refreshing the materialized view
            records_after = pg_spec_helper.connection.exec("SELECT count(*) as count from my_schema.my_materialized_view").first["count"]
            expect(records_after).to eq("0")
          end
        end
      end

      describe :refresh_materialized_view do
        it "raises an error if the provided materialized view is not being tracked" do
          expect {
            pg_spec_helper.send :refresh_materialized_view, :my_schema, :my_materialized_view
          }.to raise_error PGSpecHelper::MaterializedViews::MaterializedViewNotTrackedError
        end

        describe "when this materialized view is being tracked" do
          before(:each) do
            pg_spec_helper.track_materialized_view :my_schema, :my_materialized_view, [:create_schema, :create_table, :create_column]
          end

          it "refreshes the materialized view" do
            # assert the expected values before refreshing the materialized view
            records_before = pg_spec_helper.connection.exec("SELECT count(*) as count from my_schema.my_materialized_view").first["count"]
            expect(records_before).to eq("3")

            # empty the table and then refresh the materialized view
            pg_spec_helper.connection.exec <<-SQL
              TRUNCATE my_schema.my_table
            SQL
            pg_spec_helper.send :refresh_all_materialized_views

            # assert the expected values before refreshing the materialized view
            records_after = pg_spec_helper.connection.exec("SELECT count(*) as count from my_schema.my_materialized_view").first["count"]
            expect(records_after).to eq("0")
          end
        end
      end

      describe :assert_materialized_view_tracked! do
        it "raises an error if the provided materialized view is not being tracked" do
          expect {
            pg_spec_helper.send :assert_materialized_view_tracked!, :my_schema, :not_a_tracked_materialized_view
          }.to raise_error PGSpecHelper::MaterializedViews::MaterializedViewNotTrackedError
        end

        describe "when materialized view is being tracked" do
          before(:each) do
            pg_spec_helper.track_materialized_view :my_schema, :my_materialized_view, [:create_schema, :create_table, :create_column]
          end

          it "returns true for this materialized view name" do
            expect(pg_spec_helper.send(:assert_materialized_view_tracked!, :my_schema, :my_materialized_view)).to be true
          end
        end
      end
    end
  end
end
