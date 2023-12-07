class BidItem < ApplicationRecord
  # Associations
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # Validations
  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.current }
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :chat_enabled, inclusion: { in: [true, false] }

  # Callbacks
  # Add any necessary callbacks here

  # Scopes
  # Define any useful scopes here

  # Methods
  # Add any instance or class methods that are necessary

  # end for validations

  class << self
    # Define class methods here
  end
end
