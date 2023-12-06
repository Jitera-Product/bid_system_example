class AddNewRelationsToUsers < ActiveRecord::Migration[7.0]
  def change
    # Assuming the other models like BidItem, Bid, Deposit, etc., already exist.

    # Add a foreign key from bid_items to users
    add_reference :bid_items, :user, foreign_key: true

    # Add a foreign key from bids to users
    add_reference :bids, :user, foreign_key: true

    # Add a foreign key from deposits to users
    add_reference :deposits, :user, foreign_key: true

    # Add a foreign key from payment_methods to users
    add_reference :payment_methods, :user, foreign_key: true

    # Add a foreign key from products to users
    add_reference :products, :user, foreign_key: true

    # Add a foreign key from wallets to users
    add_reference :wallets, :user, foreign_key: true

    # Add a foreign key from chat_channels to users
    # Assuming the chat_channels table exists and has a user_id column
    add_foreign_key :chat_channels, :users

    # Add a foreign key from chat_messages to users
    # Assuming the chat_messages table exists and has a user_id column
    add_foreign_key :chat_messages, :users
  end
end
