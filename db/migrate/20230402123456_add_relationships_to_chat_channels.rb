class AddRelationshipsToChatChannels < ActiveRecord::Migration[6.0]
  def change
    # Since the chat_channels table already exists, we are adding the relationships here
    # Add a foreign key from chat_channels to bid_items
    add_foreign_key :chat_channels, :bid_items, column: :bid_item_id

    # Add a foreign key from chat_channels to users
    add_foreign_key :chat_channels, :users, column: :user_id

    # Add a foreign key from chat_messages to chat_channels
    # This is already done in the CreateChatMessages migration, so no action is needed here
  end
end
