class AddUserIdToOwners < ActiveRecord::Migration[7.0]
  def change
    add_column :owners, :user_id, :string
    add_index :owners, :user_id, unique: true
  end
end
