class ChatService
  # ... other methods ...

  # New method to check the chat channel status
  def check_chat_channel_status(chat_channel_id)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    if chat_channel
      { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
    else
      raise "ChatChannel with id #{chat_channel_id} does not exist."
    end
  end

  # ... other methods ...
end
