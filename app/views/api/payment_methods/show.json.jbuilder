if @message.present?

  json.message @message

else

  json.wallet do
    json.id @wallet.id

    json.created_at @wallet.created_at

    json.updated_at @wallet.updated_at

    json.user_id @wallet.user_id

    json.primary @wallet.primary

    json.method @wallet.method

    payment_method_withdrawal = @wallet.withdrawal
    if payment_method_withdrawal.present?
      json.payment_method_withdrawal do
        json.value payment_method_withdrawal.value

        json.status payment_method_withdrawal.status

        json.id payment_method_withdrawal.id

        json.created_at payment_method_withdrawal.created_at

        json.updated_at payment_method_withdrawal.updated_at

        json.aprroved_id payment_method_withdrawal.aprroved_id

        json.payment_method_id payment_method_withdrawal.payment_method_id
      end
    end

    json.deposits @wallet.deposits do |deposit|
      json.id deposit.id

      json.created_at deposit.created_at

      json.updated_at deposit.updated_at

      json.value deposit.value

      json.user_id deposit.user_id

      json.wallet_id deposit.wallet_id

      json.status deposit.status

      json.payment_method_id deposit.payment_method_id
    end
  end

end
