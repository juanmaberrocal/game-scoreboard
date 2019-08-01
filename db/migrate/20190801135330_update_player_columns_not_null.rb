class UpdatePlayerColumnsNotNull < ActiveRecord::Migration[6.0]
  def up
    return unless column_exists?(:players, :first_name) ||
                  column_exists?(:players, :last_name)  ||
                  column_exists?(:players, :nickname)   ||
                  column_exists?(:players, :email)

    change_column_null(:players, :first_name, false) if column_exists?(:players, :first_name)
    change_column_null(:players, :last_name, false)  if column_exists?(:players, :last_name)
    change_column_null(:players, :nickname, false)   if column_exists?(:players, :nickname)
    change_column_null(:players, :email, false, 'test@example.com') if column_exists?(:players, :email)
  end

  def down
    return unless column_exists?(:players, :first_name) ||
                  column_exists?(:players, :last_name)  ||
                  column_exists?(:players, :nickname)   ||
                  column_exists?(:players, :email)

    change_column_null(:players, :first_name, true) if column_exists?(:players, :first_name)
    change_column_null(:players, :last_name, true)  if column_exists?(:players, :last_name)
    change_column_null(:players, :nickname, true)   if column_exists?(:players, :nickname)
    change_column_null(:players, :email, true)      if column_exists?(:players, :email)
  end
end
