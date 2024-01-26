
class Message < ApplicationRecord
  # Associations
  belongs_to :chat_session
  belongs_to :user

  # Validations
  validates :content, presence: true
end
