class Message < ApplicationRecord
  # Associations
  belongs_to :chat_channel

  # Validations
  validates :content, presence: true

  # Add any additional validations here if required
end
