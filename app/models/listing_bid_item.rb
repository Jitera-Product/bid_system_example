class ListingBidItem < ApplicationRecord
  belongs_to :listing
  belongs_to :bid_item

  # validations

  # end for validations

  class << self
  end
end
