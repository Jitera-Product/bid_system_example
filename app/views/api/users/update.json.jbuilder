if @error_object.present?
  json.error_object @error_object
else
  json.user do
    json.id @user.id
    json.name @user.name
    json.kyc_status @user.kyc_status
    json.kyc_documents @user.kyc_documents do |kyc_document|
      json.id kyc_document.id
      json.document_type kyc_document.document_type
      json.document_file kyc_document.document_file
      json.status kyc_document.status
    end
  end
end
