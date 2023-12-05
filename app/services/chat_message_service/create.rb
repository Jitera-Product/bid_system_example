# /app/services/chat_message_service/create.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChatMessageService::Create
  include ActiveModel::Model

  attr_accessor :channel_id, :message, :current_user

  validates :channel_id, presence: { message: 'Chat channel not found.' }
  validates :message, presence: true, length: { maximum: 256, too_long: 'Message exceeds 256 characters limit.' }
  validate :chat_channel_exists
  validate :message_count_within_limit
  validate :user_authenticated

  def initialize(channel_id:, message:, current_user:)
    @channel_id = channel_id
    @message = message
    @current_user = current_user
  end

  def execute
    return errors.full_messages unless valid?

    create_chat_message
  end

  private

  def chat_channel_exists
    errors.add(:channel_id, 'Chat channel not found.') unless ChatChannel.exists?(id: channel_id)
  end

  def message_count_within_limit
    if ChatMessage.where(chat_channel_id: channel_id).count >= 500
      errors.add(:base, 'Maximum messages per channel limit reached.')
    end
  end

  def user_authenticated
    errors.add(:base, 'User must be authenticated.') unless current_user.present?
  end

  def create_chat_message
    ActiveRecord::Base.transaction do
      chat_message = ChatMessage.create!(
        chat_channel_id: channel_id,
        message: message,
        user_id: current_user.id
      )
      chat_message
    end
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.full_messages
  end
end
# rubocop:enable Style/ClassAndModuleChildren
