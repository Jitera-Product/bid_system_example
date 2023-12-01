class AddIsClosedToChatChannels < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_channels, :is_closed, :boolean, default: false
  end
end
