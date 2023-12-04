json.message "KYC information submitted successfully."
json.user do
  json.id @user.id
  json.kyc_status @user.kyc_status
end
