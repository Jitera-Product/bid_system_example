class AddUsernameIsOwnerToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :username, :string, null: false, default: ''
    add_column :users, :is_owner, :boolean, default: false

    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
    remove_column :users, :is_owner
  end
end
