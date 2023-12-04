class AddNewColumnsToUsersTable < ActiveRecord::Migration[6.0]
  def change
    # Add new columns to the users table
    add_column :users, :password, :string
    add_column :users, :password_confirmation, :string
  end
end
