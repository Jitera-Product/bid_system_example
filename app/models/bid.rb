class Bid < ApplicationRecord
  # Existing associations
  has_one :shipping, dependent: :destroy
  belongs_to :item, class_name: 'BidItem', foreign_key: 'bid_item_id' # Updated foreign_key
  belongs_to :user

  # Existing enum for status
  enum status: { new: 'new', paid: 'paid', refund: 'refund' }, _suffix: true

  # Existing validations
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }

  # New association based on the updated ERD
  # Assuming that the User model has a primary key named 'user_id'
  # and the Shipping model has a foreign key named 'bid_id'
  belongs_to :user, foreign_key: 'user_id'
  has_many :shippings, foreign_key: 'bid_id', dependent: :destroy

  # Update validations for price to remove the upper limit constraint
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }

  # Custom methods if needed
  # ...

  # Class methods if needed
  class << self
    # ...
  end
end
