class AddNewRelationsToUsers < ActiveRecord::Migration[7.0]
  def change
    # Add foreign key for bid_items.user_id
    add_foreign_key :bid_items, :users, column: :user_id

    # Add foreign key for bids.user_id
    add_foreign_key :bids, :users, column: :user_id

    # Add foreign key for deposits.user_id
    add_foreign_key :deposits, :users, column: :user_id

    # Add foreign key for payment_methods.user_id
    add_foreign_key :payment_methods, :users, column: :user_id

    # Add foreign key for products.user_id
    add_foreign_key :products, :users, column: :user_id

    # Add foreign key for wallets.user_id
    add_foreign_key :wallets, :users, column: :user_id

    # Add foreign key for chat_channels.user_id
    # Assuming chat_channels table exists and has a user_id column
    add_foreign_key :chat_channels, :users, column: :user_id

    # Add foreign key for messages.user_id
    # Assuming messages table exists and has a user_id column
    add_foreign_key :messages, :users, column: :user_id
  end
end
