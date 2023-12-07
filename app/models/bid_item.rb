class BidItem < ApplicationRecord
  # Existing associations
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy # New association

  belongs_to :user
  belongs_to :product

  # Existing enum
  enum status: %w[draft ready done], _suffix: true

  # Existing validations
  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :expiration_time, presence: true
  validates :expiration_time, timeliness: { type: :datetime, on_or_after: -> { DateTime.current } }
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, if: :name?
  validates :is_chat_enabled, inclusion: { in: [true, false] }
  validates :status, presence: true

  # New column validation
  validates :chat_enabled, inclusion: { in: [true, false] }

  # New association (assuming the related model and foreign key are correctly named)
  has_many :bids, class_name: 'Bid', foreign_key: 'bid_item_id', dependent: :destroy

  # Methods and other logic can be added here
end
