
class Message < ApplicationRecord
  # Associations
  belongs_to :chat_session
  has_many :users, through: :chat_sessions
  belongs_to :user
  has_many :users, through: :user

  # Validations
  validates :message_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Validations
  validates :content, presence: true
end
