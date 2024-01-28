class ChatMessage < ApplicationRecord
  # Associations
  belongs_to :chat_session

  # Validations
  validates_length_of :message, maximum: 512, too_long: I18n.t('activerecord.errors.messages.too_long', count: 512)
  validates :message, presence: true
  validates :chat_session_id, presence: true

  # Callbacks
  after_create :increment_message_count

  private

  def increment_message_count
    chat_session.increment!(:message_count)
    chat_session.update!(is_active: false) if chat_session.message_count >= 30
  end
end

