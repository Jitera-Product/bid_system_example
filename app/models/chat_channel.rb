class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # Validations
  validates :bid_item_id, presence: true
end
