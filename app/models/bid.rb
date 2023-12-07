class Bid < ApplicationRecord
  # Existing associations
  has_one :shipping, dependent: :destroy
  belongs_to :user

  # Updated association for item
  belongs_to :item,
             class_name: 'BidItem',
             foreign_key: :item_id, # Ensure the foreign key is specified
             inverse_of: :item_bids

  # Existing enum for status
  enum status: %w[new paid refund], _suffix: true

  # Existing validations
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }

  # Add new associations for bid_items
  has_many :bid_items, dependent: :destroy

  # Add new validations for status
  validates :status, presence: true, inclusion: { in: Bid.statuses.keys }

  # Add new validations for user_id
  validates :user_id, presence: true

  # Add new validations for item_id
  validates :item_id, presence: true

  # Add timestamps validations
  validates :created_at, presence: true
  validates :updated_at, presence: true

  # Business logic (if any needed) goes here

  class << self
    # Class methods (if any needed) go here
  end
end
