class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update submit_kyc_info]
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
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    result = UpdateKycStatusService.new(@user, params[:kyc_info]).execute
    if result.success?
      @user.update(kyc_status: 'Verified')
      render status: :ok
    else
      @error_object = result.errors
      render status: :unprocessable_entity
    end
  end
  def update_kyc_status
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    if @user.kyc_status != 'Complete'
      @user.update(kyc_status: 'Incomplete')
      NotificationService.new(@user.id, 'Your KYC status has been updated to Incomplete. Some features may be restricted.').send_notification
    end
    render json: { kyc_status: @user.kyc_status, message: 'Your KYC status has been updated.' }
  end
end
