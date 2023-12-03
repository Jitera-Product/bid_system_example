# /app/services/chat_channel_service.rb

class ChatChannelService
  # Existing methods...

  # Add the new method below
  def close_chat_by_owner(chat_channel_id, owner_id)
    # Validate that the "owner_id" matches the logged-in user's ID
    # This assumes that there is a method `current_user_id` available which returns the logged-in user's ID
    raise CustomError.new('User is not logged in or does not match the owner') unless owner_id == current_user_id

    # Retrieve the chat channel using the provided "chat_channel_id"
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise CustomError.new('Chat channel not found') if chat_channel.nil?

    # Check if the chat channel exists and if the logged-in user is the owner of the associated BidItem
    unless ChatChannelPolicy.new(chat_channel, owner_id).user_is_owner?
      raise CustomError.new('User does not have permission to close the chat')
    end

    # If the user is the owner, update the "is_active" attribute of the chat channel to `false`
    chat_channel.update!(is_active: false)

    # Return a success message upon successfully closing the chat
    { success: true, message: 'Chat channel successfully closed' }
  end

  private

  # This method should be defined to return the current logged-in user's ID
  def current_user_id
    # Assuming there is a method to access the current user, otherwise this method needs to be implemented
    Current.user&.id
  end
end
