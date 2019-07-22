class GameTableColumnUpdates < ActiveRecord::Migration[6.0]
  def up
    change_column :games, :name, :string, null: false
    change_column :games, :slug, :string, null: false
    add_index :games, :slug, unique: true
  end

  def down
    change_column :games, :name, :string, null: true
    change_column :games, :slug, :string, null: true
    remove_index :games, :slug
  end
end
