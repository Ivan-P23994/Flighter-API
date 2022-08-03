class AddUniqueIndexToUserRole < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :token, :text, default: nil, index: { unique: true } # rubocop:disable Rails/ReversibleMigration
  end
end
