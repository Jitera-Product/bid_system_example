class AddNewRelationshipsToChatMessages < ActiveRecord::Migration[6.0]
  def change
    # Assuming the chat_channels and users tables already exist with the necessary columns.
    # No changes are made to the existing CreateChatMessages migration file.
    # Instead, a new migration file is created to add the relationships.

    # Add a foreign key from chat_messages to chat_channels
    add_foreign_key :chat_messages, :chat_channels, column: :chat_channel_id

    # Add a foreign key from chat_messages to users
    add_foreign_key :chat_messages, :users, column: :user_id
  end
end
