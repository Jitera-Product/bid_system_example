class AddUsernameAndRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, null: false, default: ''
    add_column :users, :role, :integer, null: false, default: 0

    add_index :users, :username, unique: true
  end
end
