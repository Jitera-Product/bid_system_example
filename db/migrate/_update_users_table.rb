class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    # Add new columns or modify existing ones as per new requirements
    # Example: Adding a new column 'nickname' to the 'users' table
    add_column :users, :nickname, :string

    # Example: Changing the type of the 'email' column from string to text
    change_column :users, :email, :text

    # Example: Removing the 'password_confirmation' column
    remove_column :users, :password_confirmation

    # Example: Adding an index to the 'nickname' column
    add_index :users, :nickname, unique: true

    # Example: Adding a foreign key to 'user_id' column in 'bid_items' table
    # This assumes that the 'bid_items' table and 'users' table are already created
    # and that the 'bid_items' table has a 'user_id' column.
    add_foreign_key :bid_items, :users
  end
end
