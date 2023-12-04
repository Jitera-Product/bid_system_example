class KycDocuments::CreateService
  def initialize(user, params)
    @user = user
    @params = params
  end
  def call
    validate_input
    store_documents
    update_user_kyc_status
    { status: @user.kyc_status, message: 'KYC information submitted successfully.' }
  end
  private
  def validate_input
    # Validation logic here
    # Check the format of the input, the validity of the documents (e.g., whether they are expired), and whether the input matches the documents.
    # If the validation fails, raise an error with a message to the user to correct their input or upload valid documents.
  end
  def store_documents
    @user.kyc_documents.create!(@params)
  end
  def update_user_kyc_status
    @user.update!(kyc_status: 'Verified')
  end
end
