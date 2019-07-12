class CreateMatchPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :match_players do |t|
      t.references :match, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.boolean :winner

      t.timestamps
    end
  end
end
