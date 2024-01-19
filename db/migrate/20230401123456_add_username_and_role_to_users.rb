# frozen_string_literal: true

class AddUsernameAndRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, null: false, default: ""
    add_column :users, :role, :integer, default: 0

    # Assuming that the role column is an enum in the User model and you want to add an index for it
    add_index :users, :role
  end
end
