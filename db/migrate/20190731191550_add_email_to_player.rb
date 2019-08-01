class AddEmailToPlayer < ActiveRecord::Migration[6.0]
  def up
    return if column_exists?(:players, :email)
    add_column(:players, :email, :string, after: :nickname)
  end

  def down
    return unless column_exists?(:players, :email)
    remove_column(:players, :email)
  end
end
