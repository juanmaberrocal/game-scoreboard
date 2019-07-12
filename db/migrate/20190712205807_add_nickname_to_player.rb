class AddNicknameToPlayer < ActiveRecord::Migration[6.0]
  def up
    return if column_exists?(:players, :nickname)
    add_column(:players, :nickname, :string, after: :last_name)
  end

  def down
    return unless column_exists?(:players, :nickname)
    drop_column(:players, :nickname)
  end
end
