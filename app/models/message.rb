class Message < ApplicationRecord
  # Associations
  belongs_to :chat_channel

  # Validations
  validates :content, presence: true

  # Attributes
  # id, created_at, updated_at, content, chat_channel_id are handled by Rails
end
