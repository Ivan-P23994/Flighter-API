class AddUniqueIndexToUserRoleColumn < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :token, :text, default: nil, index: { unique: true }
  end

  def down
    remove_column :users, :token
  end
end
