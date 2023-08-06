# frozen_string_literal: true

class PGSpecHelper
  module Triggers
    # create a trigger
    class UnexpectedEventManipulationError < StandardError
    end

    class UnexpectedActionOrientationError < StandardError
    end

    class UnexpectedActionTimingError < StandardError
    end

    class UnexpectedConditionsError < StandardError
    end

    # create a postgres trigger
    def create_trigger schema_name, table_name, name, action_timing:, event_manipulation:, action_orientation:, routine_schema:, routine_name:, action_condition: nil, action_reference_old_table: nil, action_reference_new_table: nil
      unless [:insert, :delete, :update].include? event_manipulation
        raise UnexpectedEventManipulationError, event_manipulation
      end

      unless action_condition.nil? || action_condition.is_a?(String)
        raise UnexpectedConditionsError, "expected String but got `#{action_condition}`"
      end

      unless [:row, :statement].include? action_orientation
        raise UnexpectedActionOrientationError, action_orientation
      end

      unless [:before, :after, :instead_of].include? action_timing
        raise UnexpectedActionTimingError, action_timing
      end

      # "INSTEAD OF/BEFORE/AFTER" "INSERT/UPDATE/DELETE"
      timing_sql = "#{action_timing.to_s.sub("_", " ")} #{event_manipulation}".upcase

      condition_sql = action_condition.nil? ? "" : "WHEN (#{action_condition})"

      temp_tables = []
      unless action_reference_old_table.nil?
        temp_tables << "OLD TABLE AS #{action_reference_old_table}"
      end
      unless action_reference_new_table.nil?
        temp_tables << "NEW TABLE AS #{action_reference_new_table}"
      end
      temp_tables_sql = temp_tables.any? ? "REFERENCING #{temp_tables.join(" ")}" : ""

      connection.exec <<~SQL
        -- trigger names only need to be unique for this table
        CREATE TRIGGER #{name}
          #{timing_sql} ON #{schema_name}.#{table_name} #{temp_tables_sql}
            FOR EACH #{action_orientation}
              #{condition_sql}
              EXECUTE FUNCTION #{routine_schema}.#{routine_name}();
      SQL
    end

    # return a list of trigger names for the provided table
    def get_trigger_names schema_name, table_name
      # get the trigger names
      rows = connection.exec(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT
        trigger_name
        FROM
          information_schema.triggers
        WHERE
          event_object_schema = $1
          AND event_object_table = $2
      SQL
      rows.map { |r| r["trigger_name"].to_sym }
    end
  end
end
