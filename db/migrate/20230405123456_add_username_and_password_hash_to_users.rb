class AddUsernameAndPasswordHashToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, null: false, default: ""
    add_column :users, :password_hash, :string, null: false, default: ""
  end
end
