
class ChatChannel < ApplicationRecord
  belongs_to :bid_item, foreign_key: 'bid_item_id'
  has_many :messages, foreign_key: 'chat_channel_id', dependent: :destroy

  # validations
  validates :status, presence: true

end
