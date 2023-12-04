class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :bid_item_id, dependent: :destroy # Updated foreign_key from :item_id to :bid_item_id
  has_many :listing_bid_items, dependent: :destroy

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true
  validates :expiration_time, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }

  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  validates :status, presence: true, inclusion: { in: BidItem.statuses.keys }

  validates :product_id, presence: true
  validates :user_id, presence: true

  validates :is_locked, inclusion: { in: [true, false] }

  validates :description, presence: true, length: { maximum: 1000 } # Added validation for description

  # end for validations

  # Custom methods, callbacks, scopes etc. (if any)

  # Add any new associations below this line
  # For example, if you add a new relation 'has_many :reviews', you might add:
  # has_many :reviews, dependent: :destroy

  # Add any new validations below this line
  # For example, if you add a new column 'nickname', you might add:
  # validates :nickname, presence: true, length: { maximum: 50 }

  # Add any new methods below this line
  # For example, if you add a method 'display_name', you might add:
  # def display_name
  #   "#{self.name} - #{self.base_price}"
  # end
end
