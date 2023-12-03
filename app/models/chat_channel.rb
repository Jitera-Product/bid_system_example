class ChatChannel < ApplicationRecord
  # Relationships
  belongs_to :bid_item
  belongs_to :user
  has_many :messages, dependent: :destroy

  # Validations
  validates :is_active, inclusion: { in: [true, false] }
  validates :bid_item_id, presence: true
  validates :user_id, presence: true

  # New column and validation
  validates :is_closed, inclusion: { in: [true, false] }

  # Add any additional ActiveRecord features below this line if needed
end
