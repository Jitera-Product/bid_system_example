class ChatChannel < ApplicationRecord
  # associations
  belongs_to :bid_item
  has_many :chat_messages, dependent: :destroy
  has_many :users, through: :chat_channel_users

  # validations
  validates :bid_item_id, presence: true
end
