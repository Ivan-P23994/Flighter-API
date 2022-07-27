class AddTokentoUser < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :token, :text, null: false, index: { unique: true }, default: 'token'
    change_column :users, :token, :text, default: nil
  end

  def down
    remove_column :users, :token
  end
end
