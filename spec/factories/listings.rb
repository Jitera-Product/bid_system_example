FactoryBot.define do
  factory :listing do
    description { Faker::Lorem.paragraph_by_chars(number: 65_535) }
  end
end
