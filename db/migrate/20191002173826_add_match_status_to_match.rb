class AddMatchStatusToMatch < ActiveRecord::Migration[6.0]
  def up
    # return if column_exists?(:matches, :match_status)
    # add_column(:matches, :match_status, :integer, after: :game_id, null: false, default: 0)

    # Match.update_all(match_status: :confirmed)
  end

  def down
    # return unless column_exists?(:matches, :match_status)
    # remove_column(:matches, :match_status)
  end
end
