FactoryBot.define do
  factory :product_category do
    category { create(:category) }

    product { create(:product) }
  end
end
