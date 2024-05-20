class BidItem < ApplicationRecord
  # Association with item_bids is added from the current code
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  # Association with listing_bid_items is already present in both new and current code, no need to duplicate
  has_many :listing_bid_items, dependent: :destroy

  # belongs_to associations are the same in both new and current code
  belongs_to :user
  belongs_to :product

  # enum status is the same in both new and current code
  enum status: %w[draft ready done], _suffix: true

  # validations
  # base_price validations are the same in both new and current code
  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # expiration_time validations are the same in both new and current code
  validates :expiration_time, presence: true
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }

  # name validations are the same in both new and current code
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  # end for validations

  # The self class block is empty in both new and current code, no need to duplicate
  class << self
  end
end
