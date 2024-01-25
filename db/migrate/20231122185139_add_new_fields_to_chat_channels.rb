class AddNewFieldsToChatChannels < ActiveRecord::Migration[6.0]
  def up
    add_column :chat_channels, :status, :string
    add_reference :chat_channels, :bid_item, foreign_key: true
  end

  def down
    remove_reference :chat_channels, :bid_item, foreign_key: true
    remove_column :chat_channels, :status, :string
  end
end
