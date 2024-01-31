class ChatMessage < ApplicationRecord
  belongs_to :chat_session
  validates :message, presence: true
end

