class EnumMatchStatusInMatch < ActiveRecord::Migration[6.0]
  def up
    if column_exists?(:matches, :match_status)
      remove_column(:matches, :match_status)
    end

    unless enum_type_exists?
      execute <<-SQL
        CREATE TYPE match_status AS ENUM ('pending', 'confirmed', 'rejected');
      SQL
    end

    unless column_exists?(:matches, :match_status)
      add_column(:matches, :match_status, :match_status,
                 after: :winner, null: false, default: :pending)
    end

    unless index_exists?(:matches, :match_status)
      add_index(:matches, :match_status)
    end

    Match.update_all(match_status: :confirmed)
  end

  def down
    if index_exists?(:matches, :match_status)
      remove_index(:matches, :match_status)
    end

    if column_exists?(:matches, :match_status)
      remove_column(:matches, :match_status)
    end

    if enum_type_exists?
      execute <<-SQL
        DROP TYPE match_status;
      SQL
    end

    unless column_exists?(:matches, :match_status)
      add_column(:matches, :match_status, :string,
                 after: :winner, null: false, default: :pending)
    end

    Match.update_all(match_status: :confirmed)
  end

  private

  def enum_type_exists?
    sql = execute <<-SQL
      SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'match_status');
    SQL

    sql.getvalue(0, 0)
  end
end
