# This migration is responsible for creating the chat_channels table
class CreateChatChannelsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_channels do |t|
      t.timestamps

      t.references :bid_item, null: false, foreign_key: true
    end

    add_index :chat_channels, :bid_item_id
  end
end
