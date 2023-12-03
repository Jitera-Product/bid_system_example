# /app/services/message_retrieval_service.rb
class MessageRetrievalService
  # Existing methods...
  def retrieve_chat_messages(chat_channel_id)
    raise StandardError.new('Chat channel does not exist') unless ChatChannel.exists?(chat_channel_id)
    messages = Message.where(chat_channel_id: chat_channel_id)
                      .includes(:user)
                      .order(created_at: :desc)
                      .limit(200)
                      .as_json(only: [:user_id, :content, :created_at], include: { user: { only: :username } })
    messages.map do |message|
      {
        sender_id: message['user_id'],
        content: message['content'],
        created_at: message['created_at']
      }
    end
  rescue StandardError => e
    handle_error(e)
  end
  private
  def handle_error(error)
    # Assuming there is a method to handle errors
    raise error
  end
end
