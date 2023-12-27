class AddUsernamePasswordHashRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, null: false, default: ''
    add_column :users, :password_hash, :string
    add_column :users, :role, :integer, default: 0

    add_index :users, :username, unique: true
  end
end
