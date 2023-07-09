RSpec.describe PGSpecHelper do
  describe :TrackChanges do
    let(:database_configuration) { RSpec.configuration.database_configuration.to_h }
    let(:pg_spec_helper) { PGSpecHelper.new(**database_configuration) }

    describe :has_changes? do
      describe "when the optional method_name is not provided" do
        it "returns false" do
          expect(pg_spec_helper.has_changes?).to be false
        end

        describe "when changes have been made" do
          before(:each) do
            pg_spec_helper.create_schema :test_schema
          end

          it "returns true" do
            expect(pg_spec_helper.has_changes?).to be true
          end
        end
      end

      describe "when the optional method_name is provided" do
        it "returns false" do
          expect(pg_spec_helper.has_changes?(:create_schema)).to be false
        end

        it "raises an error if the method_name does not exist" do
          expect {
            pg_spec_helper.has_changes?(:not_a_real_method)
          }.to raise_error PGSpecHelper::TrackChanges::UntrackableMethodNameError
        end

        describe "when changes have been made" do
          before(:each) do
            pg_spec_helper.create_schema :test_schema
          end

          it "returns true" do
            expect(pg_spec_helper.has_changes?(:create_schema)).to be true
          end

          it "returns false when testing for a different method name" do
            expect(pg_spec_helper.has_changes?(:create_table)).to be false
          end
        end
      end
    end

    describe :track_change do
      it "raises an error if the method_name does not exist" do
        expect {
          pg_spec_helper.has_changes?(:not_a_real_method)
        }.to raise_error PGSpecHelper::TrackChanges::UntrackableMethodNameError
      end

      it "adds the method_name to the list of methods which have been tracked" do
        expect(pg_spec_helper.has_changes?(:create_schema)).to be false

        pg_spec_helper.send :track_change, :create_schema

        expect(pg_spec_helper.has_changes?(:create_schema)).to be true
      end
    end

    describe :methods_used do
      it "returns an empty hash" do
        expect(pg_spec_helper.send(:methods_used)).to eql({})
      end

      describe "when changes have been made" do
        before(:each) do
          pg_spec_helper.create_schema :test_schema
        end

        it "returns a hash representation of the changes" do
          expect(pg_spec_helper.send(:methods_used)).to eql({
            create_schema: true
          })
        end
      end
    end

    describe :assert_trackable_method_name! do
      it "raises an error if the method_name does not exist" do
        expect {
          pg_spec_helper.send(:assert_trackable_method_name!, :not_a_real_method)
        }.to raise_error PGSpecHelper::TrackChanges::UntrackableMethodNameError
      end

      it "returns true if the  method_name does exist" do
        expect(pg_spec_helper.send(:assert_trackable_method_name!, :create_schema)).to be true
      end
    end

    describe :install_trackable_methods do
      # note, this method is called from the initializer so we do not call it again here

      it "replaces certain methods with a new method which tracks the method call and then calls the original method" do
        # assert the method has not yet been tracked
        expect(pg_spec_helper.has_changes?(:create_schema)).to be false
        # assert the schema does not yet exist
        expect(pg_spec_helper.schema_exists?(:test_schema)).to be false

        # call the tracked method `create_schema`
        pg_spec_helper.create_schema :test_schema

        # assert the method was tracked
        expect(pg_spec_helper.has_changes?(:create_schema)).to be true
        # assert the schema now exists (that the original method was called)
        expect(pg_spec_helper.schema_exists?(:test_schema)).to be true
      end
    end
  end
end
