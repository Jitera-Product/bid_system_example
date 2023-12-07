class ChatChannel < ApplicationRecord
  # associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # validations
  validates :bid_item_id, presence: true

  # Add any new associations, validations, or methods below this line
  # New associations or methods can be added here as per future requirements
end
