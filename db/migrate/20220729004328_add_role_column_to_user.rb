class AddRoleColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, default: nil
  end
end
