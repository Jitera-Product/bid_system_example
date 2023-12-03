class ChatChannelService
  # ... other methods ...
  def close_chat_channel(chat_channel_id, owner_id)
    ActiveRecord::Base.transaction do
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      raise CustomError.new("Chat channel not found") unless chat_channel
      # Assuming User model exists and has a method to check if a user is logged in
      owner = User.find_by(id: owner_id)
      raise CustomError.new("User not found or not logged in") unless owner&.logged_in?
      raise CustomError.new("You are not authorized to close this chat channel") unless chat_channel.owner_id == owner_id
      chat_channel.update!(is_active: false)
      { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
    end
  rescue ActiveRecord::RecordInvalid => e
    raise CustomError.new(e.message)
  end
end
