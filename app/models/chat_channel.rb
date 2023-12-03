class ChatChannel < ApplicationRecord
  # associations
  belongs_to :bid_item
  belongs_to :user
  has_many :messages, dependent: :destroy
  # validations
  validates :is_active, inclusion: { in: [true, false] }
  validates :bid_item_id, presence: true
  validates :user_id, presence: true
  # methods specific to ChatChannel can be added here
end
