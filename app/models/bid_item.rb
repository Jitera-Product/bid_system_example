class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :chat_sessions, dependent: :destroy

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true

  validates :base_price, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }
  validates :status, presence: true
  validates :expiration_time, presence: true

  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }

  validates :name, presence: true

  validates :name, length: { in: 0..255 }, if: :name?
  validates :product_id, presence: true
  validates :user_id, presence: true

  # end for validations

  class << self
  end
end
