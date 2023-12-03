class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy # New relationship

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true
  # Removed the incorrect validation range for base_price
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true
  # Updated the validation to check for expiration_time to be on or after the current time instead of DateTime.tomorrow
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: -> { Time.current } }

  validates :name, presence: true
  # Updated the length validation to use the correct range
  validates :name, length: { maximum: 255 }, if: :name?

  validates :title, presence: true # New validation for title
  validates :title, length: { maximum: 255 }, if: :title? # New validation for title length

  validates :description, length: { maximum: 65_535 }, if: :description? # New validation for description

  validates :is_paid, inclusion: { in: [true, false] } # New validation for is_paid

  # end for validations

  class << self
  end
end
