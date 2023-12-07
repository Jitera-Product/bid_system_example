class Message < ApplicationRecord
  belongs_to :chat_channel
  belongs_to :user

  # validations

  validates :content, presence: true
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true

  # Add a new column 'sent_at' to the Message model
  validates :sent_at, presence: true

  # end for validations
end
