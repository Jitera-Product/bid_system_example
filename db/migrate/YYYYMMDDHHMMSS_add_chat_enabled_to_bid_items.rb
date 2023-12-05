# frozen_string_literal: true

class AddChatEnabledToBidItems < ActiveRecord::Migration[6.1]
  def change
    # Check if the column already exists before trying to add it
    unless column_exists?(:bid_items, :chat_enabled)
      add_column :bid_items, :chat_enabled, :boolean, default: false, null: false
    end
  end
end
