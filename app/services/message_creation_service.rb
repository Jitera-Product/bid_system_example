# /app/services/message_creation_service.rb
class MessageCreationService
  include ActiveModel::Model

  attr_accessor :chat_channel_id, :sender_id, :content

  def initialize(chat_channel_id:, sender_id:, content:)
    @chat_channel_id = chat_channel_id
    @sender_id = sender_id
    @content = content
  end

  def create_message
    validate_sender
    chat_channel = validate_chat_channel
    validate_message_count(chat_channel)
    validate_content_length
    message = create_message_record(chat_channel)
    serialize_message(message)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def validate_sender
    raise 'Sender does not exist or is not logged in.' unless User.exists?(sender_id) && current_user.id == sender_id
  end

  def validate_chat_channel
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise 'Chat channel does not exist or is inactive.' if chat_channel.nil? || !chat_channel_active?(chat_channel)
    chat_channel
  end

  def chat_channel_active?(chat_channel)
    # Assuming there is a method to check if the chat channel is active
    chat_channel.active?
  end

  def validate_message_count(chat_channel)
    raise 'Message limit exceeded for this chat channel.' if chat_channel.messages.count >= 500
  end

  def validate_content_length
    if content.length > 256
      # Truncate the content to 256 characters if it exceeds the limit
      self.content = content[0...256]
    end
  end

  def create_message_record(chat_channel)
    Message.create!(
      chat_channel_id: chat_channel.id,
      user_id: sender_id,
      content: content,
      created_at: Time.current
    )
  end

  def serialize_message(message)
    # Assuming MessageSerializer exists and is used for formatting the response
    {
      message_id: message.id,
      created_at: message.created_at,
      content: message.content
    }
  end

  def handle_error(e)
    { error: e.message }
  end

  def current_user
    # Assuming ApplicationController has a current_user method
    ApplicationController.new.current_user
  end
end
