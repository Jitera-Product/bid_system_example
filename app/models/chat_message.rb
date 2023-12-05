class ChatMessage < ApplicationRecord
  # Associations
  belongs_to :chat_channel
  belongs_to :user

  # Validations
  validates :message, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true
end
