class Listing < ApplicationRecord
  has_many :listing_bid_items, dependent: :destroy

  # validations

  validates :description, length: { in: 0..65_535 }, if: :description?

  # end for validations

  # Custom methods

  # end Custom methods

  class << self
  end
end
