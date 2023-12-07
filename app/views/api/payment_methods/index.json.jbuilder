# Display the status code
json.status 200
# Loop through each payment method and display its details
json.paymentmethods @payment_methods do |payment_method|
  json.extract! payment_method, :id, :created_at, :updated_at, :name, :status
end
