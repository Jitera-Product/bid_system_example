class UpdateChatSessions < ActiveRecord::Migration[6.0]
  def up
    add_column :chat_sessions, :status, :integer, default: 0 unless column_exists?(:chat_sessions, :status)
    add_reference :chat_sessions, :bid_item, foreign_key: true unless column_exists?(:chat_sessions, :bid_item_id)
  end

  def down
    remove_column :chat_sessions, :status if column_exists?(:chat_sessions, :status)
    remove_reference :chat_sessions, :bid_item if column_exists?(:chat_sessions, :bid_item_id)
  end
end
