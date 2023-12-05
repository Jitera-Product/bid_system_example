class BidItem < ApplicationRecord
  # Existing relationships from both versions
  belongs_to :product
  belongs_to :user
  has_many :listing_bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy # Assuming Bid model has bid_item_id as foreign key

  # Merged enum status with both existing and new statuses
  enum status: { draft: 0, ready: 1, done: 2, active: 3, expired: 4, sold: 5 }

  # Merged validations
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true, length: { maximum: 255 }, if: :name?
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: -> { DateTime.current } }

  # Custom validations
  validate :expiration_time_cannot_be_in_the_past

  # Custom methods
  def expiration_time_cannot_be_in_the_past
    if expiration_time.present? && expiration_time < DateTime.now
      errors.add(:expiration_time, "can't be in the past")
    end
  end

  # Additional business logic can be added here

  # Class methods or scopes can be added here

end
