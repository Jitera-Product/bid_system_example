class AddForeignKeysToUsers < ActiveRecord::Migration[6.0]
  def change
    # Check if the foreign keys already exist before adding them to avoid duplication
    unless foreign_key_exists?(:bid_items, :user)
      add_foreign_key :bid_items, :users, column: :user_id
    end

    unless foreign_key_exists?(:bids, :user)
      add_foreign_key :bids, :users, column: :user_id
    end

    unless foreign_key_exists?(:deposits, :user)
      add_foreign_key :deposits, :users, column: :user_id
    end

    unless foreign_key_exists?(:payment_methods, :user)
      add_foreign_key :payment_methods, :users, column: :user_id
    end

    unless foreign_key_exists?(:products, :user)
      add_foreign_key :products, :users, column: :user_id
    end

    unless foreign_key_exists?(:wallets, :user)
      add_foreign_key :wallets, :users, column: :user_id
    end
  end
end
