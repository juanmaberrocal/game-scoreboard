class AddMinMaxPlayTimeToGame < ActiveRecord::Migration[6.0]
  def up
    return if column_exists?(:games, :min_play_time) &&
              column_exists?(:games, :max_play_time)

    add_column(:games, :min_play_time, :integer, after: :max_players)   unless column_exists?(:games, :min_play_time)
    add_column(:games, :max_play_time, :integer, after: :min_play_time) unless column_exists?(:games, :max_play_time)
  end

  def down
    return unless column_exists?(:games, :min_play_time) ||
                  column_exists?(:games, :max_play_time)

    remove_column(:games, :min_play_time) if column_exists?(:games, :min_play_time)
    remove_column(:games, :max_play_time) if column_exists?(:games, :max_play_time)
  end
end
