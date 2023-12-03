class ChatChannel < ApplicationRecord
  # Relationships
  belongs_to :bid_item
  belongs_to :user
  has_many :messages, dependent: :destroy

  # Validations
  validates :is_active, inclusion: { in: [true, false] }
  validates :is_closed, inclusion: { in: [true, false] }
end
