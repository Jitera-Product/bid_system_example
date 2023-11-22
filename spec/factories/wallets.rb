FactoryBot.define do
  factory :wallet do
    user { create(:user) }

    balance { 2_147_483_648.0 }

    locked { false }
  end
end
