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

  # Update the numericality validation for base_price to remove the upper limit
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true

  # Update the validation for expiration_time to ensure it is in the future
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: -> { DateTime.current } }

  validates :name, presence: true

  # Update the length validation for name to set the correct range
  validates :name, length: { maximum: 255 }, if: :name?

  # New validations
  validates :is_chat_enabled, inclusion: { in: [true, false] }
  validates :status, presence: true

  # end for validations

  class << self
  end
end
