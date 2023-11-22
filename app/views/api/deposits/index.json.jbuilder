if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.deposits @deposits do |deposit|
    json.id deposit.id

    json.created_at deposit.created_at

    json.updated_at deposit.updated_at

    json.value deposit.value

    user = deposit.user
    if user.present?
      json.user do
        json.id user.id

        json.created_at user.created_at

        json.updated_at user.updated_at

        json.email user.email
      end
    end

    json.user_id deposit.user_id

    wallet = deposit.wallet
    if wallet.present?
      json.wallet do
        json.id wallet.id

        json.created_at wallet.created_at

        json.updated_at wallet.updated_at

        json.balance wallet.balance

        json.user_id wallet.user_id
      end
    end

    json.wallet_id deposit.wallet_id

    json.status deposit.status

    payment_method = deposit.payment_method
    if payment_method.present?
      json.payment_method do
        json.user_id payment_method.user_id

        json.primary payment_method.primary

        json.id payment_method.id

        json.created_at payment_method.created_at

        json.updated_at payment_method.updated_at

        json.method payment_method.method
      end
    end

    json.payment_method_id deposit.payment_method_id
  end

end
