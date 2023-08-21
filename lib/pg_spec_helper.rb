# frozen_string_literal: true

require "yaml"
require "pg"

require "pg_spec_helper/version"

require "pg_spec_helper/connection"
require "pg_spec_helper/ignored_schemas"
require "pg_spec_helper/schemas"
require "pg_spec_helper/tables"
require "pg_spec_helper/columns"
require "pg_spec_helper/validations"
require "pg_spec_helper/foreign_keys"
require "pg_spec_helper/unique_constraints"
require "pg_spec_helper/primary_keys"
require "pg_spec_helper/indexes"
require "pg_spec_helper/triggers"
require "pg_spec_helper/functions"
require "pg_spec_helper/enums"
require "pg_spec_helper/extensions"
require "pg_spec_helper/models"
require "pg_spec_helper/materialized_views"
require "pg_spec_helper/reset"
require "pg_spec_helper/empty_database"
require "pg_spec_helper/track_changes"

require "pg_spec_helper/table_executer"

class PGSpecHelper
  class MissingRequiredOptionError < StandardError
  end

  include Connection
  include IgnoredSchemas
  include Schemas
  include Tables
  include Columns
  include Validations
  include ForeignKeys
  include UniqueConstraints
  include PrimaryKeys
  include Indexes
  include Triggers
  include Functions
  include Extensions
  include Enums
  include Models
  include MaterializedViews
  include Reset
  include EmptyDatabase
  include TrackChanges

  attr_reader :database, :username, :password, :host, :port

  def initialize database:, username:, host:, port:, password: nil
    # assert that all required options are present
    raise MissingRequiredOptionError, "database is required" if database.nil?
    raise MissingRequiredOptionError, "host is required" if host.nil?
    raise MissingRequiredOptionError, "username is required" if username.nil?

    # record the configuration
    @database = database
    @host = host
    @port = port || 5432
    @username = username
    # password is optional
    @password = password

    # the TrackChanges module is used to track high level changes which are
    # made to the database using this class, this allows us to reach out to the
    # database and reset it only when needed.
    #
    # The `install_trackable_methods` method will override the methods which
    # we are tracking with a new proxy method which will record when the method
    # is called before subsequently calling the original method.
    install_trackable_methods
  end
end
