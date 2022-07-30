class AddUniqueIndexToUserRoleColumn < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :token, :text, default: nil, unique: true
  end

  def down
    remove_column :users, :token
  end
end
