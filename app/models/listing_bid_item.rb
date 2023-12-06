class ListingBidItem < ApplicationRecord
  belongs_to :listing
  belongs_to :bid_item

  # validations
  validates :up_vote, numericality: { greater_than_or_equal_to: 0, less_than: 2147483650 }, allow_nil: true
  # end for validations

  class << self
  end
end
