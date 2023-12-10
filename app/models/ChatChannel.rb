class ChatChannel < ApplicationRecord
  # relationships
  belongs_to :bid_item
  has_many :chat_messages, dependent: :destroy

  # validations
  validates_presence_of :bid_item_id
end
