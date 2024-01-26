class AddUserIdToChatMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :chat_messages, :user, foreign_key: true
  end

  def down
    remove_reference :chat_messages, :user, foreign_key: true
  end
end
