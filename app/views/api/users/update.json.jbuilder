if @error_object.present?
  json.error_object @error_object
else
  json.user do
    json.id @user.id
    json.name @user.name
    json.kyc_status @user.kyc_status
    json.document_type @user.document_type
    json.document_file @user.document_file
    json.status @user.status
  end
  json.message "Your KYC information has been successfully submitted and is under review."
end
