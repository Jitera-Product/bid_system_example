
class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, foreign_key: :bid_item_id, dependent: :destroy
  has_many :chat_sessions, foreign_key: :bid_item_id, dependent: :destroy

  belongs_to :user
  belongs_to :product
  # Add new relationships if any new foreign keys are added to the table

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true

  # Update the numericality validation to reflect any changes in constraints
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :expiration_time, presence: true

  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }

  validates :name, presence: true

  validates :name, length: { in: 0..255 }, if: :name?

  # end for validations

  class << self
  end
end
