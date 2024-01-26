class ChatSession < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages

  # Validations
  validates :is_active, inclusion: { in: [true, false] }

  # Add any additional callbacks or methods below if necessary
end

