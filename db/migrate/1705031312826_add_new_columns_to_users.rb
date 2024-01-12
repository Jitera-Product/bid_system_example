class AddNewColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    # Add new columns to the users table
    add_column :users, :username, :string, null: false, default: ''
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :password_hash, :string, null: false, default: ''

    # Add indexes for the new username column
    add_index :users, :username, unique: true

    # Add foreign key relationships for the new user_id columns in related tables
    add_reference :bid_items, :user, foreign_key: true
    add_reference :bids, :user, foreign_key: true
    add_reference :deposits, :user, foreign_key: true
    add_reference :payment_methods, :user, foreign_key: true
    add_reference :products, :user, foreign_key: true
    add_reference :wallets, :user, foreign_key: true
    add_reference :questions, :user, foreign_key: true
  end
end
