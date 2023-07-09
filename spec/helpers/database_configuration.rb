# frozen_string_literal: true

module Helpers
  class DatabaseConfiguration
    class MissingConfigurationError < StandardError
    end

    class ConfigurationNotLoadedError < StandardError
    end

    class MissingRequiredNameError < StandardError
    end

    attr_reader :database, :username, :password, :host, :port

    def initialize name
      load_configuration_for name
      @database = require_configuration_value(:database).to_sym
      @host = require_configuration_value :host
      @port = require_configuration_value :port
      @username = require_configuration_value :username
      @password = optional_configuration_value :password
    end

    def to_h
      {
        database: @database,
        host: @host,
        port: @port,
        username: @username,
        password: @password
      }
    end

    def load_configuration_for name
      raise MissingRequiredNameError unless name

      @name = name.to_s

      configuration = load_configuration_file

      if configuration[@name].nil?
        raise MissingConfigurationError, "no configuration found for `#{name}` in database.yaml"
      end

      @configuration = configuration[@name]
    end

    # returns the configuration value if it exists, else nil
    def optional_configuration_value key
      @configuration[key.to_s]
    end

    # returns the configuration value if it exists, else raises an error
    def require_configuration_value key
      raise ConfigurationNotLoadedError unless @configuration
      @configuration[key.to_s] || raise(MissingConfigurationError, "no `#{key}` found for configuration `#{@name}`")
    end

    # opens the configuration yaml file, and returns the contents as a hash
    def load_configuration_file
      YAML.load_file("config/database.yaml")
    end
  end
end
