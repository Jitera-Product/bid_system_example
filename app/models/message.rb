class Message < ApplicationRecord
  # Associations
  belongs_to :chat_channel
  belongs_to :user

  # Validations
  validates :content, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true

  # Custom methods (if any)
  # ...
end
