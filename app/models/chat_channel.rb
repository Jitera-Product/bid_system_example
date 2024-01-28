
class ChatChannel < ApplicationRecord
  belongs_to :bid_item, foreign_key: 'bid_item_id'
  has_many :messages, foreign_key: 'chat_channel_id', dependent: :destroy

  # validations
  validates :bid_item_id, presence: true
  validates :status, presence: true
  validates :message_count, presence: true
end
