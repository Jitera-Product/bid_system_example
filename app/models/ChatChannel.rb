class ChatChannel < ApplicationRecord
  # associations
  belongs_to :bid_item
  belongs_to :user
  has_many :chat_messages, dependent: :destroy

  # validations
  validates :bid_item_id, presence: true
  validates :user_id, presence: true

  # Add any new associations here if required in the future
end
