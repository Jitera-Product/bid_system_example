class ChatSession < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :chat_messages

  # Validations
  validates :is_active, presence: true
  validates :bid_item_id, presence: true
end

