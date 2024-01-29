class Message < ApplicationRecord
  # Associations
  belongs_to :chat_channel

  # Validations
  validate :sender_must_exist
  validates :content, presence: true, length: { maximum: 512, too_long: I18n.t('activerecord.errors.messages.message_content_length', count: 512) }

  def sender_must_exist
    errors.add(:sender_id, I18n.t('activerecord.errors.messages.sender_must_exist')) unless User.exists?(self.sender_id)
  end

  # Attributes
  # id, created_at, updated_at, content, chat_channel_id are handled by Rails
end
