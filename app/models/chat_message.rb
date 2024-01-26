class ChatMessage < ApplicationRecord
  # Associations
  belongs_to :chat_session

  # Validations
  validates :message, presence: true
  validates :chat_session_id, presence: true
end

