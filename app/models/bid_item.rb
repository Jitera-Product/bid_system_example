class BidItem < ApplicationRecord
  # Existing associations
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy

  # Updated relationships
  belongs_to :user
  belongs_to :product

  # New relationships
  has_many :bids, dependent: :destroy # Assuming Bid model has bid_item_id as foreign key

  enum status: { draft: 0, ready: 1, done: 2 }

  # validations

  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true
  validates :expiration_time, timeliness: { type: :datetime, on_or_after: -> { DateTime.current } }

  validates :name, presence: true
  validates :name, length: { maximum: 255 }, if: :name?

  # end for validations

  class << self
  end
end
