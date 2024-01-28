class AddMessageCountToChatMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_messages, :message_count, :integer, default: 0, null: false
  end

  def down
    remove_column :chat_messages, :message_count
  end
end

