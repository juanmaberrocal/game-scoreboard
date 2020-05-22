class CreatePlayerGames < ActiveRecord::Migration[6.0]
  def up
    unless table_exists?(:player_games)
      create_table :player_games do |t|
        t.references :player, null: false, foreign_key: true
        t.references :game, null: false, foreign_key: true
        t.boolean :favorite

        t.timestamps
      end
    end

    unless index_exists?(:player_games, %i[player_id game_id])
      add_index :player_games, %i[player_id game_id], unique: true
    end

    create_player_games
  end

  def down
    return unless table_exists?(:player_games)

    drop_table :player_games
  end

  private

  def create_player_games
    Player.find_each do |player|
      game_ids = player.matches.pluck(:game_id).uniq

      game_ids.each do |game_id|
        PlayerGame.find_or_create_by(player: player, game_id: game_id)
      end
    end
  end
end
