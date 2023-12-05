# frozen_string_literal: true

class UpdateChatChannelsTable < ActiveRecord::Migration[6.1]
  def change
    # Assuming we need to add a new column 'status' to the chat_channels table
    add_column :chat_channels, :status, :integer, default: 0, null: false

    # Assuming we need to add a new column 'user_id' to create a relationship with users table
    add_reference :chat_channels, :user, foreign_key: true

    # Assuming we need to add an index on the 'bid_item_id' column for better query performance
    add_index :chat_channels, :bid_item_id
  end
end
