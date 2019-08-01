class AddPlayerIndexes < ActiveRecord::Migration[6.0]
  def up
    Rake::Task['players:unique_emails'].invoke

    add_index :players, [:first_name, :last_name]
    add_index :players, :nickname, unique: true
    add_index :players, :email, unique: true
  end

  def down
    remove_index :players, [:first_name, :last_name]
    remove_index :players, :nickname
    remove_index :players, :email
  end
end
