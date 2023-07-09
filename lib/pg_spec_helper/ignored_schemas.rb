# frozen_string_literal: true

class PGSpecHelper
  module IgnoredSchemas
    # add a schema to the list of ignored schemas
    def ignore_schema schema_name
      @ignored_schemas ||= []
      @ignored_schemas << schema_name.to_sym
    end

    # get a list of ignored schemas
    def ignored_schemas
      ([:information_schema] + (@ignored_schemas || []))
    end
  end
end
