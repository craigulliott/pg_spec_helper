class PGSpecHelper
  module Reset
    # reset the database to its original state
    def reset! force = false
      if force || has_changes?
        delete_all_schemas
        # refresh all materialized views
        refresh_all_materialized_views
        # reset the tracking of changes
        @methods_used = {}
      end
    end
  end
end
