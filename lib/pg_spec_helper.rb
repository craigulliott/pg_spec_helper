# frozen_string_literal: true

require "yaml"
require "pg"

require "pg_spec_helper/version"

require "pg_spec_helper/configuration"
require "pg_spec_helper/connection"
require "pg_spec_helper/schemas"
require "pg_spec_helper/tables"
require "pg_spec_helper/columns"
require "pg_spec_helper/validations"
require "pg_spec_helper/foreign_keys"
require "pg_spec_helper/unique_constraints"
require "pg_spec_helper/primary_keys"
require "pg_spec_helper/indexes"
require "pg_spec_helper/validation_cache"
require "pg_spec_helper/structure_cache"
require "pg_spec_helper/foreign_key_cache"
require "pg_spec_helper/index_cache"

class PGSpecHelper
  include Configuration
  include Connection
  include Schemas
  include Tables
  include Columns
  include Validations
  include ForeignKeys
  include UniqueConstraints
  include PrimaryKeys
  include Indexes
  include ValidationCache
  include StructureCache
  include ForeignKeyCache
  include IndexCache

  attr_reader :database, :username, :password, :host, :port

  def initialize name
    load_configuration_for :postgres, name

    @database = require_configuration_value(:database).to_sym
    @host = require_configuration_value :host
    @port = require_configuration_value :port
    @username = require_configuration_value :username
    @password = optional_configuration_value :password

    # will be set to true if any changes are made to the database structure
    # this is used to determine if the structure needs to be reset between tests
    @has_changes = false
  end

  def has_changes?
    @has_changes
  end

  def reset! force = false
    if force || @has_changes
      delete_all_schemas cascade: true
      # note that the database has been reset and there are no changes
      @has_changes = false
    end
  end
end
