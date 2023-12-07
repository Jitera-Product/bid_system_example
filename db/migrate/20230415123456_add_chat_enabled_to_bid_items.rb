class AddChatEnabledToBidItems < ActiveRecord::Migration[6.0]
  def change
    # Since the 'is_chat_enabled' column already exists, we are renaming it to 'chat_enabled'
    rename_column :bid_items, :is_chat_enabled, :chat_enabled
  end
end
