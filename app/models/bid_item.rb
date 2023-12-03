class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy
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
  validates :title, presence: true
  validates :title, length: { in: 0..255 }, if: :title?
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :is_paid, inclusion: { in: [true, false] }
  # end for validations
  class << self
  end
end
