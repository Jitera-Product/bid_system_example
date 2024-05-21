if @message.present?
  json.message @message
else
  json.total_pages @total_pages
  json.withdrawals @withdrawals do |withdrawal|
    json.status withdrawal.status
    json.id withdrawal.id
    json.created_at withdrawal.created_at
    json.updated_at withdrawal.updated_at
    json.value withdrawal.value

    approved = withdrawal.approved
    if approved.present?
      json.approved do
        json.id approved.id
        json.created_at approved.created_at
        json.updated_at approved.updated_at
        json.name approved.name
        json.email approved.email
      end
    end
    json.approved_id withdrawal.approved_id

    payment_method = withdrawal.payment_method
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
    json.payment_method_id withdrawal.payment_method_id
  end
end