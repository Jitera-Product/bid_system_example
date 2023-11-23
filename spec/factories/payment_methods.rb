FactoryBot.define do
  factory :payment_method do
    user { create(:user) }

    primary { false }
  end
end
