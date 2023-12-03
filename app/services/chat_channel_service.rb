# PATH: /app/services/chat_channel_service.rb
class ChatChannelService
  # ... (other methods in the service)
  # Add the new method as per the guideline
  def check_chat_closure_by_owner(chat_channel_id)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise CustomError.new('Chat has been closed by the owner.') if chat_channel&.is_active == false
  end
  # ... (other methods in the service)
end
