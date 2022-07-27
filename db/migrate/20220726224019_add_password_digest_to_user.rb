class AddPasswordDigestToUser < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :password_digest, :text, null: false, default: 'password'
    change_column :users, :password_digest, :text, default: nil
  end

  def down
    remove_column :users, :password_digest
  end
end
