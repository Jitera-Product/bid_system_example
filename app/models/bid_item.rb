class BidItem < ApplicationRecord
  belongs_to :product
  belongs_to :user
  has_many :listing_bid_items
  has_many :chat_channels
  has_many :chats
  enum status: %w[draft ready done], _suffix: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }
  validates :name, presence: true, length: { in: 0..255 }, if: :name?
  validates :is_paid, inclusion: { in: [true, false] }
end
