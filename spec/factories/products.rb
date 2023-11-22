FactoryBot.define do
  factory :product do
    user { create(:user) }

    admin { create(:admin) }

    name { Faker::Lorem.paragraph_by_chars(number: 255) }

    price { 2_147_483_648.0 }

    description { Faker::Lorem.paragraph_by_chars(number: 65_535) }

    image { Rack::Test::UploadedFile.new('spec/fixtures/assets/image.png', 'image/png') }

    stock { 2_147_483_648.0 }
  end
end
