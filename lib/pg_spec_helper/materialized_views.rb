# frozen_string_literal: true

class PGSpecHelper
  module MaterializedViews
    class MaterializedViewNotTrackedError < StandardError
    end

    # add the name of a materialized view to a list of views which will
    # be refreshed after each type of change
    def track_materialized_view schema_name, materialized_view_name, refresh_after
      @materialized_views ||= {}
      @materialized_views[schema_name.to_sym] ||= {}

      # ensure the refresh_after contains at least one trackable method
      unless refresh_after.is_a?(Array) && refresh_after.count
        raise ArgumentError, "refresh_after must be an array of trackable method names"
      end

      # ensure each method in the refresh_after list is trackable
      refresh_after.each do |method_name|
        assert_trackable_method_name! method_name
      end

      @materialized_views[schema_name.to_sym][materialized_view_name.to_sym] = {
        # assume does not exist until proven otherwise
        exists: false,
        # list of methods which should trigger a refresh of this
        # materialized view
        refresh_after: refresh_after
      }
    end

    private

    # given a trackable method name, refreshes any materialized
    # views which are configured to be refreshed after that method
    def refresh_materialized_views_by_method method_name
      assert_trackable_method_name! method_name
      # check each materialized view to see if it should be refreshed
      @materialized_views&.each do |schema_name, views|
        views.each do |materialized_view_name, view|
          # if the materialized view exists and the method name is in the list of
          # this materialized view's refresh_after methods, then refresh the view
          if view[:refresh_after].include?(method_name) && materialized_view_exists?(schema_name, materialized_view_name)
            refresh_materialized_view schema_name, materialized_view_name
          end
        end
      end
    end

    # return true if the materialized view exists, otherwise false
    def materialized_view_exists? schema_name, materialized_view_name
      # assert this materialized view is being tracked
      assert_materialized_view_tracked! schema_name, materialized_view_name

      # return true if we've already determined that the materialized view exists
      # otherwise, check the database and cache the result of the existance check
      #
      # the check will be made every time the method is called, until the first
      # time the materialized view is found to exist, at which point the method
      # will always return true
      @materialized_views[schema_name.to_sym][materialized_view_name.to_sym][:exists] ||= connection.exec(<<~SQL).count > 0
        SELECT TRUE AS exists FROM pg_matviews WHERE schemaname = '#{sanitize_name schema_name}' AND matviewname = '#{sanitize_name materialized_view_name}';
      SQL
    end

    # refresh all materialized views that have been tracked
    def refresh_all_materialized_views
      @materialized_views&.each do |schema_name, views|
        views.each do |materialized_view_name, view|
          if materialized_view_exists? schema_name, materialized_view_name
            refresh_materialized_view schema_name, materialized_view_name
          end
        end
      end
    end

    # whenever schema changes are made from within the test suite we need to
    # rebuild the materialized views that hold a cached representation of the
    # database structure
    def refresh_materialized_view schema_name, materialized_view_name
      # assert this materialized view is being tracked
      assert_materialized_view_tracked! schema_name, materialized_view_name

      # refresh the view if it exists
      if materialized_view_exists? schema_name, materialized_view_name
        connection.exec(<<~SQL)
          REFRESH MATERIALIZED VIEW #{connection.quote_ident schema_name.to_s}.#{connection.quote_ident materialized_view_name.to_s};
        SQL
      end
    end

    # assert that the provided materialized view is being tracked
    def assert_materialized_view_tracked! schema_name, materialized_view_name
      # assert any materialized views are being tracked
      if @materialized_views.nil?
        raise MaterializedViewNotTrackedError, "no materialized views are being tracked"
      end
      # assert this materialized view is being tracked
      unless @materialized_views.key? schema_name.to_sym
        raise MaterializedViewNotTrackedError, "no materialized views for schema `#{schema_name}` are being tracked"
      end
      # assert this materialized view is being tracked
      unless @materialized_views[schema_name.to_sym].key? materialized_view_name.to_sym
        raise MaterializedViewNotTrackedError, "materialized view `#{schema_name}`.`#{materialized_view_name}` is not being tracked"
      end
      # the materialized view does exist, so return true
      true
    end
  end
end
