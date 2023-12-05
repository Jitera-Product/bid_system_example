class Listing < ApplicationRecord
  has_many :listing_bid_items, dependent: :destroy

  # validations

  validates :description, length: { in: 0..65_535 }, if: :description?

  # end for validations

  # Custom logic can be placed here

  class << self
    # Class methods can be placed here
  end
end
