
class ChatMessage < ApplicationRecord
  # Associations
  belongs_to :chat_session
  belongs_to :user

  # Validations
  validates :message_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Validations
  validates :message, presence: true
  validates :chat_session_id, presence: true
  validates :user_id, presence: true
end
