# frozen_string_literal: true

class AddIsChatEnabledToBidItems < ActiveRecord::Migration[6.1]
  def change
    add_column :bid_items, :is_chat_enabled, :boolean, default: false
  end
end
