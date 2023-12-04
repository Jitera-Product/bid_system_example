class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update verify_kyc update_kyc_status]
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
  def verify_kyc
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    if @user.update(kyc_status: params[:kyc_status])
      render json: { message: "KYC status updated to #{params[:kyc_status]}", kyc_status: @user.kyc_status }
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  def update_kyc_status
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    if @user.update(kyc_status: 'Incomplete')
      send_notification(@user.id, "Your KYC status has been updated to 'Incomplete'. Please complete the KYC process to regain full access to your account.")
      render json: { message: "KYC status updated to 'Incomplete'", kyc_status: @user.kyc_status }
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  def send_notification(user_id, message)
    # Implement the logic to send notification to the user
  end
end
