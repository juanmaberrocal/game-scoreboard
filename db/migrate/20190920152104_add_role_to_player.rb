class AddRoleToPlayer < ActiveRecord::Migration[6.0]
  def up
    return if column_exists?(:players, :role)
    add_column(:players, :role, :integer, after: :nickname, null: false, default: 1)
  end

  def down
    return unless column_exists?(:players, :role)
    remove_column(:players, :role)
  end
end
