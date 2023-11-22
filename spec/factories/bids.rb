FactoryBot.define do
  factory :bid do
    bid_item { create(:bid_item) }

    user { create(:user) }

    status { Bid.statuses.keys[0] }

    price { 2_147_483_648.0 }
  end
end
