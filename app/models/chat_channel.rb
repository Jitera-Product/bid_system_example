class ChatChannel < ApplicationRecord
  belongs_to :user
  belongs_to :bid_item
  has_many :messages, dependent: :destroy
  validates :is_closed, inclusion: { in: [true, false] }
end
