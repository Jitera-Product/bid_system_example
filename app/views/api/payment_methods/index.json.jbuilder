if @message.present?
  json.message @message
else
  json.total_pages @total_pages
  json.payment_methods @payment_methods do |payment_method|
    json.id payment_method.id
    json.created_at payment_method.created_at
    json.updated_at payment_method.updated_at
    json.name payment_method.name
    json.status payment_method.status
  end
end
