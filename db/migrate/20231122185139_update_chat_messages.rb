class UpdateChatMessages < ActiveRecord::Migration[6.0]
  def up
    add_column :chat_messages, :message, :text unless column_exists?(:chat_messages, :message)
    add_reference :chat_messages, :chat_session, foreign_key: true unless column_exists?(:chat_messages, :chat_session_id)
  end

  def down
    remove_column :chat_messages, :message if column_exists?(:chat_messages, :message)
    remove_reference :chat_messages, :chat_session if column_exists?(:chat_messages, :chat_session_id)
  end
end
