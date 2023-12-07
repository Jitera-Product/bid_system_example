# /app/services/message_service.rb
class MessageService
  include ActiveModel::Validations

  validate :validate_message_limit, on: :create
  validate :validate_content_length, on: :create

  def initialize(user_id, chat_channel_id, content)
    @user_id = user_id
    @chat_channel_id = chat_channel_id
    @content = content
  end

  def send_message
    return { error: 'User must be logged in' } unless user_logged_in?(@user_id)
    validate_presence
    return unless errors.empty?

    chat_channel = ChatChannel.find(@chat_channel_id)
    return handle_excess_messages if chat_channel.messages.count >= 500

    if @content.length > 256
      return { error: 'Content length exceeds 256 characters' }
    end

    message = Message.create!(
      user_id: @user_id,
      chat_channel_id: @chat_channel_id,
      content: @content,
      created_at: Time.current
    )

    message.attributes.slice('id', 'chat_channel_id', 'user_id', 'content', 'created_at')
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

  private

  def user_logged_in?(user_id)
    # Assuming there is a method to check if a user is logged in
    # This is a placeholder for the actual implementation
    User.find_by(id: user_id).present?
  end

  def validate_presence
    MessageValidator.new(@user_id, @chat_channel_id, @content).validate
    errors.add(:base, 'Invalid inputs') unless MessageValidator.valid?
  end

  def validate_message_limit
    chat_channel = ChatChannel.find(@chat_channel_id)
    if chat_channel.messages.count >= 500
      errors.add(:base, 'Message limit exceeded for the chat channel')
    end
  end

  def validate_content_length
    errors.add(:content, 'Content length exceeds 256 characters') if @content.length > 256
  end

  def handle_excess_messages
    # Implement logic to archive or delete old messages
    # This is a placeholder for the actual implementation
    { error: 'Message limit exceeded for the chat channel' }
  end
end
