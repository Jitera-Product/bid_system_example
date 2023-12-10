class AddChatEnabledToBidItems < ActiveRecord::Migration[6.0]
  def change
    add_column :bid_items, :chat_enabled, :boolean, default: false
  end
end
