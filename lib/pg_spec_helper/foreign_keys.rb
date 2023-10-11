# frozen_string_literal: true

class PGSpecHelper
  module ForeignKeys
    # Create a foreign key
    def create_foreign_key schema_name, table_name, column_names, foreign_schema_name, foreign_table_name, foreign_column_names, foreign_key_name, deferrable: false, initially_deferred: false, on_delete: :no_action, on_update: :no_action
      # allow it to be deferred, and defer it by default
      deferrable_sql = if initially_deferred
        "DEFERRABLE INITIALLY DEFERRED"

      # allow it to be deferred, but do not deferr by default
      elsif deferrable
        "DEFERRABLE INITIALLY IMMEDIATE"

      # it can not be deferred (this is the default)
      else
        "NOT DEFERRABLE"
      end

      column_names_sql = column_names.join(", ")
      foreign_column_names_sql = foreign_column_names.join(", ")

      # add the foreign key
      connection.exec(<<~SQL)
        ALTER TABLE #{schema_name}.#{table_name}
          ADD CONSTRAINT #{foreign_key_name}
          FOREIGN KEY (#{column_names_sql})
              REFERENCES #{foreign_schema_name}.#{foreign_table_name} (#{foreign_column_names_sql})
            ON DELETE #{referential_action_to_sql on_delete}
            ON UPDATE #{referential_action_to_sql on_update}
          #{deferrable_sql};

      SQL
    end

    # returns a list of foreign keys for the provided table
    def get_foreign_key_names schema_name, table_name
      rows = connection.exec_params(<<~SQL, [schema_name.to_s, table_name.to_s])
        SELECT constraint_name
        FROM information_schema.table_constraints
        WHERE table_schema = $1
          AND table_name = $2
          AND constraint_type = 'FOREIGN KEY'
        ORDER BY constraint_name;
      SQL
      rows.map { |row| row["constraint_name"].to_sym }
    end

    private

    def referential_action_to_sql referential_action
      case referential_action
      # Produce an error indicating that the deletion or update would create a
      # foreign key constraint violation. If the constraint is deferred, this
      # error will be produced at constraint check time if there still exist
      # any referencing rows. This is the default action.
      when :no_action
        "NO ACTION"

      # Produce an error indicating that the deletion or update would create a
      # foreign key constraint violation. This is the same as NO ACTION except
      # that the check is not deferrable.
      when :restrict
        "RESTRICT"

      # Delete any rows referencing the deleted row, or update the values of
      # the referencing column(s) to the new values of the referenced columns,
      # respectively.
      when :cascade
        "CASCADE"

      # Set all of the referencing columns, or a specified subset of the
      # referencing columns, to null.
      when :set_null
        "SET NULL"

      # Set all of the referencing columns, or a specified subset of the
      # referencing columns, to their default values.
      when :set_default
        "SET DEFAULT"

      else
        raise UnexpectedReferentialActionError, referential_action
      end
    end
  end
end
