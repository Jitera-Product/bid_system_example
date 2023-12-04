class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update submit_kyc_info update_kyc_status manual_kyc_verification]
  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end
  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end
  def create
    @user = User.new(create_params)
    authorize @user, policy_class: Api::UsersPolicy
    return if @user.save
    @error_object = @user.errors.messages
    render status: :unprocessable_entity
  end
  def create_params
    params.require(:users).permit(:email)
  end
  def update
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    return if @user.update(update_params)
    @error_object = @user.errors.messages
    render status: :unprocessable_entity
  end
  def update_params
    params.require(:users).permit(:email)
  end
  def submit_kyc_info
    begin
      @user = UserService.submit_kyc_info(submit_kyc_info_params)
      if @user.kyc_status == 'Verified'
        render json: { message: 'KYC information submitted successfully.', kyc_status: @user.kyc_status }, status: :ok
      else
        render json: { error: 'KYC validation failed. Please correct your input or upload valid documents.' }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  def update_kyc_status
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    UserService::UpdateKycStatus.new(@user, params[:kyc_status]).execute
    # Send notification to the user
    UserMailer.with(user: @user).kyc_status_email.deliver_later
    render json: { message: 'KYC status updated successfully', user: @user }, status: :ok
  end
  def manual_kyc_verification
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    begin
      UserService::ManualKycVerification.new(@user, params[:kyc_status], params[:status]).execute
      render json: { message: 'KYC status updated successfully', kyc_status: @user.reload.kyc_status }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  private
  def submit_kyc_info_params
    params.require(:user).permit(:id, :name, :kyc_status, :document_type, :document_file, :status)
  end
end
