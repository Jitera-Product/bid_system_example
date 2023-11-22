FactoryBot.define do
  factory :category do
    admin { create(:admin) }

    disabled { false }

    name { Faker::Lorem.paragraph_by_chars(number: 255) }
  end
end
