class AddMessageCountToChatChannels < ActiveRecord::Migration[6.0]
  def up
    add_column :chat_channels, :message_count, :integer, default: 0
  end

  def down
    remove_column :chat_channels, :message_count
  end
end
