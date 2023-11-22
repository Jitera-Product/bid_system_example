FactoryBot.define do
  factory :withdrawal do
    admin { create(:admin) }

    payment_method { create(:payment_method) }

    value { 2_147_483_648.0 }

    status { Withdrawal.statuses.keys[0] }
  end
end
