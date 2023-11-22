FactoryBot.define do
  factory :transaction do
    wallet { create(:wallet) }

    status { Transaction.statuses.keys[0] }

    reference_id { 2_147_483_648.0 }

    transaction_type { Transaction.transaction_types.keys[0] }

    value { 2_147_483_648.0 }

    reference_type { Transaction.reference_types.keys[0] }
  end
end
