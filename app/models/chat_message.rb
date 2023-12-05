class ChatMessage < ApplicationRecord
  # associations
  belongs_to :chat_channel
  belongs_to :user # Added association with user

  # validations
  validates :content, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true # Added validation for user_id

  # Add any additional methods below this line
end
