class ChatMessage < ApplicationRecord
  # associations
  belongs_to :chat_channel

  # validations
  validates :content, presence: true
  validates :chat_channel_id, presence: true

  # Add any additional methods below this line
end
