if @message.present?

  json.message @message

else

  json.wallet do
    json.id @wallet.id

    json.created_at @wallet.created_at

    json.updated_at @wallet.updated_at

    json.balance @wallet.balance

    user = @wallet.user
    if user.present?
      json.user do
        json.id user.id

        json.created_at user.created_at

        json.updated_at user.updated_at

        json.email user.email
      end
    end

    json.user_id @wallet.user_id

    json.transactions @wallet.transactions do |transaction|
      json.status transaction.status

      json.reference_id transaction.reference_id

      json.id transaction.id

      json.created_at transaction.created_at

      json.updated_at transaction.updated_at

      json.transaction_type transaction.transaction_type

      json.value transaction.value

      json.reference_type transaction.reference_type

      json.wallet_id transaction.wallet_id
    end

    json.deposits @wallet.deposits do |deposit|
      json.id deposit.id

      json.created_at deposit.created_at

      json.updated_at deposit.updated_at

      json.value deposit.value

      json.user_id deposit.user_id

      json.wallet_id deposit.wallet_id
    end

    json.locked @wallet.locked
  end

end
