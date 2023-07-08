# frozen_string_literal: true

class PGSpecHelper
  module ValidationCache
    # whenever schema changes are made from within the test suite we need to
    # rebuild the materialized views that hold a cached representation of the
    # database structure
    def refresh_validation_cache_materialized_view
      # the first time we detect the presence of the marerialized view, we no longer need to
      # check for it
      @validations_cache_exists ||= validations_cache_exists?
      if @validations_cache_exists
        connection.exec(<<~SQL)
          REFRESH MATERIALIZED VIEW public.pg_spec_helper_validations_cache;
        SQL
      end
    end

    def validations_cache_exists?
      exists = connection.exec(<<~SQL)
        SELECT TRUE AS exists FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'pg_spec_helper_validations_cache';
      SQL
      exists.count > 0
    end
  end
end
