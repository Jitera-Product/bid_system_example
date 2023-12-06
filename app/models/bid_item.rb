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

  # Update the numericality validation to remove the upper limit
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true

  # Update the validation to check expiration_time is on or after the current time instead of DateTime.tomorrow
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: -> { Time.current } }

  validates :name, presence: true

  # Update the length validation to set the correct range
  validates :name, length: { maximum: 255 }, if: :name?

  # New validation for chat_enabled
  validates :chat_enabled, inclusion: { in: [true, false] }

  # end for validations

  class << self
  end
end
