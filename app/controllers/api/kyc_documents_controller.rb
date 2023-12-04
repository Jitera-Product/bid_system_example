class Api::KycDocumentsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  # Other methods...
  def create
    @user = User.find_by('users.id = ?', params[:user_id])
    raise ActiveRecord::RecordNotFound, 'Wrong format' if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    personal_information = params[:personal_information]
    document_type = params[:document_type]
    document_file = params[:document_file]
    raise ActiveRecord::RecordInvalid, 'Personal information is required.' if personal_information.blank?
    raise ActiveRecord::RecordInvalid, 'Invalid document type.' unless ['Passport', 'Driver License', 'ID Card'].include?(document_type)
    raise ActiveRecord::RecordInvalid, 'Invalid file format.' unless document_file.is_a?(ActionDispatch::Http::UploadedFile)
    begin
      UserService.submit_kyc(@user, personal_information, document_type, document_file)
      render json: { message: 'KYC information submitted successfully. It will be reviewed shortly.' }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  def update_kyc_status
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    kyc_status = params[:kyc_status]
    status = params[:status]
    if kyc_status == 'Verified' && status == 'Verified'
      @user.update(kyc_status: 'Verified')
      @user.kyc_documents.update_all(status: 'Verified')
    elsif kyc_status == 'Not Verified' && status == 'Not Verified'
      @user.update(kyc_status: 'Not Verified')
      @user.kyc_documents.update_all(status: 'Not Verified')
    end
    UserMailer.with(user: @user).kyc_status_email.deliver_later
    render json: { kyc_status: @user.kyc_status, document_status: @user.kyc_documents.first.status }, status: :ok
  end
end
