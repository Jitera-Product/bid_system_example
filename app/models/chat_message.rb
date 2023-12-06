class ChatMessage < ApplicationRecord
  # associations
  belongs_to :chat_channel
  belongs_to :user

  # validations
  validates :message, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true
end
