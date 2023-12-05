class ChatChannel < ApplicationRecord
  # associations
  belongs_to :bid_item
  has_many :chat_messages, dependent: :destroy

  # validations
  validates :bid_item_id, presence: true
end
