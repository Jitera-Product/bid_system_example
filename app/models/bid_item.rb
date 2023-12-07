class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy # New association

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true
  # Removed the incorrect validation for base_price numericality
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true
  # Removed the duplicate presence validation for expiration_time
  validates :expiration_time, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }

  validates :name, presence: true
  # Removed the incorrect length validation for name
  validates :name, length: { maximum: 255 }, if: :name?

  # end for validations

  class << self
  end
end
