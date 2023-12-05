class Bid < ApplicationRecord
  # Existing associations
  has_one :shipping, dependent: :destroy
  belongs_to :item, class_name: 'BidItem'
  belongs_to :user

  # Existing enum for status
  enum status: { new: 0, paid: 1, refund: 2 }, _suffix: true

  # Existing validations
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }

  # Custom logic can be added here if necessary

  # Class methods or scopes can be added here
end
