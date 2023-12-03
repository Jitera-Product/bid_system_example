class ChatChannelService
  # Other methods ...

  def close_chat_channel(chat_channel_id, owner_id)
    # Ensure owner_id corresponds to a logged-in user (assuming there's a method `logged_in?`)
    raise CustomException.new('User must be logged in') unless logged_in?(owner_id)

    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise CustomException.new('Chat channel not found') unless chat_channel

    authorized = ChatChannelPolicy.new(owner_id, chat_channel).validate_owner
    raise CustomException.new('Not authorized to close this chat channel') unless authorized

    chat_channel.update!(is_active: false)
    { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
  rescue StandardError => e
    raise CustomException.new(e.message)
  end

  # Other methods ...

  private

  # Assuming there's a method to check if a user is logged in
  def logged_in?(user_id)
    # Logic to check if the user is logged in
  end
end
