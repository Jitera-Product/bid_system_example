class AddUsernameAndIsOwnerToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :is_owner, :boolean, default: false
  end
end
