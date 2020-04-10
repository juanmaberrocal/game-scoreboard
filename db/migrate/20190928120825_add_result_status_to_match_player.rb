class AddResultStatusToMatchPlayer < ActiveRecord::Migration[6.0]
  def up
    # return if column_exists?(:match_players, :result_status)
    # add_column(:match_players, :result_status, :integer, after: :winner, null: false, default: 0)

    # MatchPlayer.update_all(result_status: :confirmed)
  end

  def down
    # return unless column_exists?(:match_players, :result_status)
    # remove_column(:match_players, :result_status)
  end
end
