FactoryBot.define do
  factory :payment_method do
    user { create(:user) }

    primary { false }

    method { PaymentMethod.methods.keys[0] }
  end
end
