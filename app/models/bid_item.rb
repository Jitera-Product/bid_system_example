class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy # New association for chat_channels

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true

  # Updated validation for base_price to remove the upper limit
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true

  # Updated validation for expiration_time to ensure it is in the future
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: -> { DateTime.current } }

  validates :name, presence: true

  # Updated length validation for name
  validates :name, length: { maximum: 255 }, if: :name?

  # New validation for chat_enabled
  validates :chat_enabled, inclusion: { in: [true, false] }

  # end for validations

  class << self
  end
end
