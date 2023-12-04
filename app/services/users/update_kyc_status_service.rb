class Users::UpdateKycStatusService
  def execute(user_id, kyc_status, name, document_type, document_file, status)
    user = User.find(user_id)
    if user.update(kyc_status: kyc_status, name: name, status: status)
      KycDocument.create(user_id: user_id, document_type: document_type, document_file: document_file)
      return { message: 'KYC status updated successfully', user: user }
    else
      return { message: 'Failed to update KYC status', errors: user.errors.full_messages }
    end
  end
end
