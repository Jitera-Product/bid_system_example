class KycDocuments::CreateService
  def initialize(user, params)
    @user = user
    @params = params
  end
  def call
    validate_input
    store_documents
    update_user_kyc_status
    { status: @user.kyc_status, message: 'KYC information submitted successfully. It will be reviewed shortly.' }
  end
  private
  def validate_input
    raise 'Wrong format' unless @params[:user_id].is_a?(Numeric)
    raise 'Wrong format' unless @params[:personal_info].is_a?(Hash)
    raise 'Wrong format' unless @params[:document_file].is_a?(ActionDispatch::Http::UploadedFile)
  end
  def store_documents
    @user.kyc_documents.create!(@params)
  end
  def update_user_kyc_status
    @user.update!(kyc_status: 'Verified')
  end
end
