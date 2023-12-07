class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  belongs_to :user
  has_many :messages, dependent: :destroy

  # Validations
  validates :bid_item_id, presence: true
  validates :user_id, presence: true
end
