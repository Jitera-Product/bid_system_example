class ChatSession < ApplicationRecord
  belongs_to :bid_item
  has_many :chat_messages

  validates :is_active, inclusion: { in: [true, false] }
  validates :bid_item_id, presence: true

  # Additional model methods, scopes, etc. can be added below
end

