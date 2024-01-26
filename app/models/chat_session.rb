class ChatSession < ApplicationRecord
  # Associations
  belongs_to :bid_item
  belongs_to :user

  # Validations
  validates :bid_item_id, presence: true
  validates :user_id, presence: true
  validates :is_active, inclusion: { in: [true, false] }

end
