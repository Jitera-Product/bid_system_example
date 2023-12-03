class Message < ApplicationRecord
  belongs_to :chat_channel
  # validations
  validates :content, presence: true
  validates :chat_channel_id, presence: true
  # end for validations
end
