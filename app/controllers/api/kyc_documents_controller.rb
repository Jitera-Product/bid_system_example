class Api::KycDocumentsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    @kyc_document = KycDocument.new(create_params)
    authorize @kyc_document, policy_class: Api::KycDocumentsPolicy
    validator = KycDocumentValidator.new(@kyc_document)
    unless validator.valid?
      @error_object = validator.errors
      render status: :unprocessable_entity and return
    end
    result = KycDocuments::CreateService.new(@kyc_document).execute
    unless result.success?
      @error_object = result.errors
      render status: :unprocessable_entity and return
    end
    @user = User.find_by('users.id = ?', @kyc_document.user_id)
    raise ActiveRecord::RecordNotFound if @user.blank?
    result = Users::UpdateKycStatusService.new(@user, 'Verified').execute
    unless result.success?
      @error_object = result.errors
      render status: :unprocessable_entity and return
    end
    render json: { message: 'KYC information submitted successfully', kyc_status: @user.kyc_status }, status: :ok
  end
  private
  def create_params
    params.require(:kyc_document).permit(:id, :name, :kyc_status, :document_type, :document_file, :status, :user_id)
  end
end
