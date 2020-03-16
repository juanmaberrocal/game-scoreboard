class EnumResultStatusInMatchPlayer < ActiveRecord::Migration[6.0]
  def up
    if column_exists?(:match_players, :result_status)
      remove_column(:match_players, :result_status)
    end

    unless enum_type_exists?
      execute <<-SQL
        CREATE TYPE result_status AS ENUM ('pending', 'confirmed', 'rejected');
      SQL
    end

    unless column_exists?(:match_players, :result_status)
      add_column(:match_players, :result_status, :result_status,
                 after: :winner, null: false, default: :pending)
    end

    unless index_exists?(:match_players, :result_status)
      add_index(:match_players, :result_status)
    end

    MatchPlayer.update_all(result_status: :confirmed)
  end

  def down
    if index_exists?(:match_players, :result_status)
      remove_index(:match_players, :result_status)
    end

    if column_exists?(:match_players, :result_status)
      remove_column(:match_players, :result_status)
    end

    if enum_type_exists?
      execute <<-SQL
        DROP TYPE result_status;
      SQL
    end

    unless column_exists?(:match_players, :result_status)
      add_column(:match_players, :result_status, :string,
                 after: :winner, null: false, default: :pending)
    end

    MatchPlayer.update_all(result_status: :confirmed)
  end

  private

  def enum_type_exists?
    sql = execute <<-SQL
      SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'result_status');
    SQL

    sql.getvalue(0, 0)
  end
end
