# Check if there is a message to display
if @message.present?
  json.message @message
else
  # Display the total number of pages
  json.total_pages @total_pages
  # Loop through each payment method and display its details
  json.payment_methods @payment_methods do |payment_method|
    json.id payment_method.id
    json.created_at payment_method.created_at
    json.updated_at payment_method.updated_at
    json.name payment_method.name
    json.status payment_method.status
  end
end
