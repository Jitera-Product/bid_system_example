FactoryBot.define do
  factory :listing_bid_item do
    listing { create(:listing) }

    bid_item { create(:bid_item) }
  end
end
