FactoryBot.define do
  factory :deposit do
    user { create(:user) }

    wallet { create(:wallet) }

    payment_method { create(:payment_method) }

    value { 2_147_483_648.0 }

    status { Deposit.statuses.keys[0] }
  end
end
