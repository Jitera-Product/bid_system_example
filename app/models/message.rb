
class Message < ApplicationRecord
  belongs_to :chat_channel, foreign_key: 'chat_channel_id'
  belongs_to :user, foreign_key: 'user_id'

  # Add validations for new fields if necessary
  # For example:
  # validates :content, presence: true
end
