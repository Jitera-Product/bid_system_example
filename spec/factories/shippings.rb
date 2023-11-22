FactoryBot.define do
  factory :shipping do
    bid { create(:bid) }

    post_code { 2_147_483_648.0 }

    full_name { Faker::Lorem.paragraph_by_chars(number: 255) }

    phone_number { Faker::PhoneNumber.unique.cell_phone_in_e164[0..11] }

    email { Faker::Internet.unique.email }

    status { Shipping.statuses.keys[0] }

    shiping_address { Faker::Lorem.paragraph_by_chars(number: 255) }
  end
end
