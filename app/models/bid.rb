class Bid < ApplicationRecord
  has_one :shipping, dependent: :destroy

  belongs_to :item,
             class_name: 'BidItem',
             foreign_key: 'bid_item_id' # Updated foreign key for the association
  belongs_to :user

  enum status: %w[new paid refund], _suffix: true

  # validations

  validates :price, presence: true
  validates :amount, presence: true # Added validation for the new column 'amount'

  # The numericality validation for price seems incorrect as it only allows for a price of 0.0
  # Assuming it's a mistake, I'm updating it to allow any price greater than or equal to 0.0
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :amount, numericality: { only_integer: true, greater_than: 0 } # Added numericality validation for 'amount'

  # end for validations

  class << self
  end
end
