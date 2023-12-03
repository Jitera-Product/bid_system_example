# /app/services/chat_service.rb
class ChatService
  include Pundit::Authorization
  include AuthenticationConcern

  def initialize(current_user = nil)
    @current_user = current_user
  end

  def send_message(chat_channel_id, sender_id, content)
    validate_sender(sender_id)
    chat_channel = validate_chat_channel(chat_channel_id)
    validate_message_count(chat_channel_id)
    validate_message_content(content)

    message = create_message(chat_channel_id, sender_id, content)
    broadcast_message(message)

    format_response(message)
  end

  private

  def validate_sender(sender_id)
    raise Pundit::NotAuthorizedError unless logged_in?(sender_id)
  end

  def validate_chat_channel(chat_channel_id)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise ActiveRecord::RecordNotFound unless chat_channel && ChatChannelPolicy.new(@current_user, chat_channel).active?
    chat_channel
  end

  def validate_message_count(chat_channel_id)
    message_count = Message.where(chat_channel_id: chat_channel_id).count
    raise StandardError, 'Message limit reached for this channel' if message_count >= 200
  end

  def validate_message_content(content)
    raise StandardError, 'Message content too long' if content.length > 200
  end

  def create_message(chat_channel_id, sender_id, content)
    Message.create!(
      chat_channel_id: chat_channel_id,
      user_id: sender_id,
      content: content
    )
  end

  def broadcast_message(message)
    MessageBroadcastJob.perform_later(message)
  end

  def format_response(message)
    {
      message_id: message.id,
      created_at: message.created_at
    }
  end
end
