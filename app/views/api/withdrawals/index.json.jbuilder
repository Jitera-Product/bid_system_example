if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.withdraws @withdraws do |withdraw|
    json.status withdraw.status

    json.id withdraw.id

    json.created_at withdraw.created_at

    json.updated_at withdraw.updated_at

    json.value withdraw.value

    aprroved = withdraw.aprroved
    if aprroved.present?
      json.aprroved do
        json.id aprroved.id

        json.created_at aprroved.created_at

        json.updated_at aprroved.updated_at

        json.name aprroved.name

        json.email aprroved.email
      end
    end

    json.aprroved_id withdraw.aprroved_id

    payment_method = withdraw.payment_method
    if payment_method.present?
      json.payment_method do
        json.user_id payment_method.user_id

        json.primary payment_method.primary

        json.id payment_method.id

        json.created_at payment_method.created_at

        json.updated_at payment_method.updated_at

        json.payment_method payment_method.payment_method
      end
    end

    json.payment_method_id withdraw.payment_method_id
  end

end
