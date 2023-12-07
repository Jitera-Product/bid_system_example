class BidItem < ApplicationRecord
  # Existing associations
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :listing_bid_items, dependent: :destroy
  has_many :chat_channels, dependent: :destroy

  # Updated associations to reflect the new relationships
  belongs_to :product
  belongs_to :user
  belongs_to :bid, foreign_key: :bid_id, optional: true # New relationship

  # Existing enum
  enum status: %w[draft ready done], _suffix: true

  # Existing validations
  validates :base_price, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :expiration_time, presence: true
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?
  validates :chat_enabled, inclusion: { in: [true, false] } # New validation for chat_enabled

  # New validations for new columns
  # Assuming that the types for the new columns are as follows:
  # id: integer, base_price: decimal, name: string, expiration_time: datetime,
  # status: string, created_at: datetime, updated_at: datetime,
  # product_id: integer, user_id: integer, chat_enabled: boolean, bid_id: integer

  # No additional validations are needed for id, created_at, updated_at as they are typically handled by Rails

  # New associations for the new relationships
  # Assuming that the related models are named Product, User, and Bid respectively
  # and that the foreign keys are product_id, user_id, and bid_id respectively
  # The relationships are already defined above

  # Business logic (if any needed) should be added here

  # Scopes (if any needed) should be added here

  # Callbacks (if any needed) should be added here

  # Instance methods (if any needed) should be added here

  # Class methods (if any needed) should be added here
end
