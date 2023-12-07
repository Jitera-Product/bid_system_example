class ChatMessage < ApplicationRecord
  belongs_to :chat_channel
  belongs_to :user

  # validations
  validates :content, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true
end
