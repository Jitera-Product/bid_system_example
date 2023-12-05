# frozen_string_literal: true

class AddChatEnabledToBidItems < ActiveRecord::Migration[6.1]
  def change
    add_column :bid_items, :chat_enabled, :boolean, default: false
  end
end
