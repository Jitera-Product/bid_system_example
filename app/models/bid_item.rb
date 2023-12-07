class BidItem < ApplicationRecord
  # Existing associations
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy

  # New associations based on the updated ERD
  has_many :chat_channels, dependent: :destroy

  # Existing associations
  belongs_to :user
  belongs_to :product

  # Existing enum for status
  enum status: %w[draft ready done], _suffix: true

  # Existing validations
  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :expiration_time, presence: true
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  # New validation for chat_enabled
  validates :chat_enabled, inclusion: { in: [true, false] }

  # Existing class methods
  class << self
  end
end
