class Api::KycDocumentsController < Api::BaseController
  before_action :doorkeeper_authorize!
  def create
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    validator = KycDocumentValidator.new(params)
    unless validator.valid?
      @error_object = validator.errors
      render status: :unprocessable_entity and return
    end
    kyc_document = KycDocuments::CreateService.new(params).execute
    if kyc_document.persisted?
      Users::UpdateKycStatusService.new(@user, 'Verified').execute
      render json: { message: "KYC status updated to Verified", kyc_status: @user.reload.kyc_status }
    else
      @error_object = kyc_document.errors.messages
      render status: :unprocessable_entity
    end
  end
end
