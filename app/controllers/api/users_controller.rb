class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update submit_kyc filter_notifications]
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
  def submit_kyc
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    kyc_document = @user.kyc_documents.new(document_type: params[:document_type], document_file: params[:document_file], status: params[:status])
    if kyc_document.valid?
      @user.update(kyc_status: 'Verified')
      kyc_document.save
    else
      @error_object = kyc_document.errors.messages
      render status: :unprocessable_entity
      return
    end
    if params[:kyc_status] == 'Pending'
      @user.update(kyc_status: 'Pending')
      NotificationService.new(@user, 'Your KYC documents are under review').send
    end
    render json: { kyc_status: @user.kyc_status, document_status: kyc_document.status }
  end
  def filter_notifications
    user_id = params[:user_id]
    activity_type = params[:activity_type]
    unless UserService.validate_user_and_activity_type(user_id, activity_type)
      render json: { error: 'Invalid user_id or activity_type' }, status: :unprocessable_entity
      return
    end
    notifications = UserService.get_notifications(user_id, activity_type)
    render json: { notifications: notifications, total: notifications.count }
  end
end
