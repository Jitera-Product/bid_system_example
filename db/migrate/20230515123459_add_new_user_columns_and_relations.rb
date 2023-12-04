class AddNewUserColumnsAndRelations < ActiveRecord::Migration[6.0]
  def change
    # Adding new columns to the users table
    add_column :users, :password, :string unless column_exists?(:users, :password)
    add_column :users, :password_confirmation, :string unless column_exists?(:users, :password_confirmation)

    # Since the users table is already created, we need to add the new relations to the existing tables
    # Check if the foreign key exists before adding it to avoid duplication
    add_reference :bid_items, :user, foreign_key: true unless foreign_key_exists?(:bid_items, :user)
    add_reference :bids, :user, foreign_key: true unless foreign_key_exists?(:bids, :user)
    add_reference :deposits, :user, foreign_key: true unless foreign_key_exists?(:deposits, :user)
    add_reference :payment_methods, :user, foreign_key: true unless foreign_key_exists?(:payment_methods, :user)
    add_reference :products, :user, foreign_key: true unless foreign_key_exists?(:products, :user)
    add_reference :wallets, :user, foreign_key: true unless foreign_key_exists?(:wallets, :user)
  end
end
