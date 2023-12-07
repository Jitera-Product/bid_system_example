# /app/services/message_creation_service.rb
class MessageCreationService
  include ActiveModel::Validations
  validates_length_of :content, maximum: 256, too_long: 'Content is too long (maximum is 256 characters)'

  def initialize(current_user)
    @current_user = current_user
  end

  def create_message(user_id, chat_channel_id, content)
    raise Exceptions::AuthorizationError.new('User must be logged in') unless @current_user && @current_user.id == user_id
    
    chat_channel = ChatChannel.find_by!(id: chat_channel_id)
    validate_user_permission(user_id, chat_channel)
    validate_content_length(content)
    validate_message_count(chat_channel)
    
    message = Message.create!(chat_channel_id: chat_channel_id, user_id: user_id, content: content)
    { json: { message: 'Message has been sent' }, status: :ok }
  rescue ActiveRecord::RecordNotFound => e
    render_error_response(e.message, :not_found)
  rescue Exceptions::AuthorizationError => e
    render_error_response(e.message, :forbidden)
  rescue ActiveRecord::RecordInvalid => e
    render_error_response(e.message, :unprocessable_entity)
  end

  private

  def validate_content_length(content)
    raise ActiveRecord::RecordInvalid.new(self, :content) unless valid?
  end

  def validate_user_permission(user_id, chat_channel)
    bid_item = chat_channel.bid_item
    unless bid_item.user_id == user_id || (bid_item.chat_enabled && @current_user.id == user_id)
      raise Exceptions::AuthorizationError.new('User does not have permission to send a message in this chat channel')
    end
  end

  def validate_message_count(chat_channel)
    if chat_channel.messages.count >= 500
      raise ActiveRecord::RecordInvalid.new(self, :base), 'Maximum number of messages has been reached'
    end
  end

  def render_error_response(message, status)
    { json: { error: message }, status: status }
  end
end
