# Display the status code
json.status 200
# Loop through each payment method and display its details
json.paymentmethods @payment_methods do |payment_method|
  json.partial! 'api/payment_methods/payment_method', payment_method: payment_method
end
