class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update update_kyc_status]
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
  def update_kyc_status
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    if params[:kyc_status] == 'Incomplete'
      @user.update(kyc_status: params[:kyc_status])
      # Add code here to update user's permissions based on business logic
      # Send notification to user about the status change and feature restrictions
      NotificationService.new(@user).send_kyc_status_update_notification
    end
    render json: { kyc_status: @user.kyc_status, message: 'KYC status updated and notification sent.' }
  end
end
