# frozen_string_literal: true

class PGSpecHelper
  module Sanitize
    class UnsafePostgresNameError < StandardError
    end

    # returns a sanitized version of the provided name, raises an error
    # if it is not valid
    #
    # this is probably unnessesary due to this gem being used within a test
    # suite and not a production application, but it is here for completeness
    # and an abundance of caution
    def sanitize_name name
      # ensure the name is a string
      name = name.to_s
      # ensure the name is not empty
      raise UnsafePostgresNameError, "name cannot be empty" if name.empty?
      # ensure the name does not contain invalid characters
      raise UnsafePostgresNameError, "name contains invalid characters" unless /\A[a-zA-Z0-9_-]+\z/.match?(name)
      # return the name
      name
    end
  end
end
