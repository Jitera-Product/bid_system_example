class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update verify_kyc update_kyc_status restrict]
  before_action :set_user, only: %i[show update verify_kyc update_kyc_status restrict]
  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end
  def show
    authorize @user, policy_class: Api::UsersPolicy
  end
  def create
    @user = User.new(create_params)
    authorize @user, policy_class: Api::UsersPolicy
    return if @user.save
    @error_object = @user.errors.messages
    render status: :unprocessable_entity
  end
  def update
    authorize @user, policy_class: Api::UsersPolicy
    return if @user.update(update_params)
    @error_object = @user.errors.messages
    render status: :unprocessable_entity
  end
  def verify_kyc
    authorize @user, policy_class: Api::UsersPolicy
    if @user.update(kyc_status: params[:kyc_status])
      render json: { message: "KYC status updated to #{params[:kyc_status]}", kyc_status: @user.kyc_status }
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  def update_kyc_status
    authorize @user, policy_class: Api::UsersPolicy
    if @user.update(kyc_status: 'Incomplete')
      send_notification(@user.id, "Your KYC status has been updated to 'Incomplete'. Please complete the KYC process to regain full access to your account.")
      render json: { message: "KYC status updated to 'Incomplete'", kyc_status: @user.kyc_status }
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  def restrict
    authorize @user, policy_class: Api::UsersPolicy
    unless params[:restrict]
      render json: { error: 'Bad Request' }, status: :bad_request
      return
    end
    begin
      UserService.kyc_process_timeout(@user.id)
      render json: { status: 200, message: 'User account restricted due to incomplete KYC process.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  private
  def set_user
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
  end
  def create_params
    params.require(:users).permit(:email)
  end
  def update_params
    params.require(:users).permit(:email)
  end
  def send_notification(user_id, message)
    # Implement the logic to send notification to the user
  end
end
