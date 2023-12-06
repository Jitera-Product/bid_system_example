class ChatMessage < ApplicationRecord
  # associations
  belongs_to :chat_channel
  belongs_to :user

  # validations
  validates :message, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true

  # Add any new associations here if required in the future
  # Add any new validations here if required in the future
  # Add any custom methods here if required in the future
end
