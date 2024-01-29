class Message < ApplicationRecord
  # Associations
  belongs_to :chat_channel

  # Validations
  validates :content, presence: true,
                      length: { maximum: 512,
                                too_long: I18n.t('activerecord.errors.messages.too_long', count: 512) }

  # Attributes
  # id, created_at, updated_at, content, chat_channel_id are handled by Rails
end
