class Bid < ApplicationRecord
  # Existing associations
  has_one :shipping, dependent: :destroy
  belongs_to :item, class_name: 'BidItem'
  belongs_to :user

  # Existing enum for status
  enum status: %w[new paid refund], _suffix: true

  # Existing validations
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }

  # New association based on the updated ERD
  # Assuming that the User model has a primary key named 'user_id'
  # and the Shipping model has a foreign key named 'bid_id'
  has_many :users, foreign_key: 'user_id'
  has_many :shippings, foreign_key: 'bid_id'

  # Existing class methods
  class << self
    # Any class methods
  end
end
