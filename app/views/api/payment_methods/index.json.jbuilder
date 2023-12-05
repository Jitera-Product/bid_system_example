# Check if there is a message to display
if @message.present?
  json.message @message
else
  # Display the total number of pages
  json.total_pages @total_pages
  # Loop through each payment method and display its details
  json.payment_methods @payment_methods do |payment_method|
    json.extract! payment_method, :id, :created_at, :updated_at, :name, :status
  end
end
