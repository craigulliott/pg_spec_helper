# frozen_string_literal: true

class PGSpecHelper
  module TrackChanges
    class UntrackableMethodNameError < StandardError
    end

    # this is a list of methods that have their useage tracked, this
    # is used to determine what actions need to be taken when calling
    # reset! between tests
    TRACKED_METHOD_CALLS = [
      :create_schema,
      :delete_all_schemas,
      :create_table,
      :delete_tables,
      :create_column,
      :create_foreign_key,
      :create_index,
      :create_primary_key,
      :create_unique_constraint,
      :create_validation,
      :create_function,
      :create_trigger,
      :create_enum
    ]

    # returns true if any changes have been made to the database structure
    # optionally pass in a method name to check if that specific method was used
    def has_changes? method_name = nil
      if method_name.nil?
        methods_used.keys.count > 0
      else
        assert_trackable_method_name! method_name
        methods_used[method_name] || false
      end
    end

    private

    # track that the provided method name has been used, this allows us to determine later
    # which methods have been used and what actions need to be taken to reset the database
    def track_change method_name
      assert_trackable_method_name! method_name
      @methods_used ||= {}
      @methods_used[method_name] ||= true
    end

    # returns a hash representation of methods which have been used
    def methods_used
      @methods_used || {}
    end

    # raises an error if the provided method name is not trackable, otherwise returns true
    def assert_trackable_method_name! method_name
      unless TRACKED_METHOD_CALLS.include? method_name.to_sym
        raise UntrackableMethodNameError, "method `#{method_name}` is not trackable"
      end
      true
    end

    # overide the trackable methods and record when they are used
    # this allows us to determine what actions need to be taken
    # to reset the datasbe between tests
    def install_trackable_methods
      TRACKED_METHOD_CALLS.each do |method_name|
        # keep a pointer to the original method
        original_method = self.class.instance_method(method_name)
        # ovveride the original method
        self.class.define_method(method_name) do |*args, **kwargs|
          # note that this method was called
          track_change method_name
          # call the original method
          original_method.bind_call(self, *args, **kwargs)
          # do any materialized views need to be refreshed?
          refresh_materialized_views_by_method method_name
        end
      end
    end
  end
end
