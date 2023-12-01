class Message < ApplicationRecord
  belongs_to :chat_channel
  # validations
  validates :content, presence: true
end
