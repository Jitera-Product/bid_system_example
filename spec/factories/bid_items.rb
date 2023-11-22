FactoryBot.define do
  factory :bid_item do
    user { create(:user) }

    product { create(:product) }

    base_price { 2_147_483_648.0 }

    expiration_time { Date.current + 2 }

    status { BidItem.statuses.keys[0] }

    name { Faker::Lorem.paragraph_by_chars(number: 255) }
  end
end
