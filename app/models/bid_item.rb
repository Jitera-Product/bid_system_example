
class BidItem < ApplicationRecord
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy

  belongs_to :user
  belongs_to :product

  enum status: { draft: 0, ready: 1, done: 2 }, _suffix: true

  # validations
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }
  validates :name, presence: true, length: { maximum: 255 }

  # end for validations

  class << self
  end
end
