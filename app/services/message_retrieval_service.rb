# /app/services/message_retrieval_service.rb
require 'lib/exceptions'

class MessageRetrievalService
  def initialize
    # Initialization can be expanded if needed
  end

  def fetch_chat_messages(chat_channel_id)
    raise Exceptions::NotFound.new('Chat channel not found') unless ChatChannel.exists?(chat_channel_id)

    messages = Message.where(chat_channel_id: chat_channel_id).limit(500).map do |message|
      {
        message_id: message.id,
        sender_id: message.user_id,
        content: message.content,
        created_at: message.created_at
      }
    end

    messages
  end

  # Other methods in the service...
end
