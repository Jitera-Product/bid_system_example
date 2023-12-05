# frozen_string_literal: true

class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    # Assuming we need to add a new column 'nickname' to the users table
    add_column :users, :nickname, :string

    # Assuming we need to remove 'password_confirmation' column from the users table
    remove_column :users, :password_confirmation, :string

    # Assuming we need to change 'email' column to be case-insensitive
    change_column :users, :email, :citext

    # Assuming we need to rename 'unlock_token' to 'unlock_digest'
    rename_column :users, :unlock_token, :unlock_digest

    # Assuming we need to change the type of 'sign_in_count' from integer to bigint
    change_column :users, :sign_in_count, :bigint

    # Add an index on the nickname column for better query performance
    add_index :users, :nickname
  end
end
