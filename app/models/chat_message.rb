class ChatMessage < ApplicationRecord
  # Associations
  belongs_to :chat_session
  belongs_to :user

  # Validations
  validates :message, presence: true
  validates :chat_session_id, presence: true
  validates :user_id, presence: true
end
