
class Message < ApplicationRecord
  # Associations
  belongs_to :chat_session
  belongs_to :user

  # Validations
  validates :content, presence: true,
                      length: { maximum: 512 }
end
