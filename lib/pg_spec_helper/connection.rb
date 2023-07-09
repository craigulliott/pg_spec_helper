# frozen_string_literal: true

class PGSpecHelper
  module Connection
    class ConnectionFailedError < StandardError
    end

    def connection
      @connection ||= PG.connect(
        host: @host,
        port: @port,
        user: @username,
        password: @password,
        dbname: @database,
        sslmode: "prefer"
      )
      @connection
    end
  end
end
