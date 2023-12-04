json.message "KYC document submission successful."
json.user do
  json.kyc_status @user.kyc_status
end
