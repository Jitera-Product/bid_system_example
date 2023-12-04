class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update filter_by_category]
  def index
    @notifications = NotificationService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @notifications.total_pages
  end
  def show
    @notification = Notification.find_by!('notifications.id = ?', params[:id])
    authorize @notification, policy_class: Api::NotificationsPolicy
    render json: @notification
  end
  def create
    @notification = Notification.new(create_params)
    authorize @notification, policy_class: Api::NotificationsPolicy
    return if @notification.save
    @error_object = @notification.errors.messages
    render status: :unprocessable_entity
  end
  def create_params
    params.require(:notifications).permit(:activity_type, :details, :status, :user_id)
  end
  def update
    @notification = Notification.find_by('notifications.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @notification.blank?
    authorize @notification, policy_class: Api::NotificationsPolicy
    return if @notification.update(update_params)
    @error_object = @notification.errors.messages
    render status: :unprocessable_entity
  end
  def update_params
    params.require(:notifications).permit(:activity_type, :details, :status, :user_id)
  end
  def filter_by_category
    activity_type = params[:activity_type]
    if Notification.activity_types.include?(activity_type)
      begin
        @notifications = NotificationService::FilterByCategory.new(current_resource_owner.id, activity_type).execute
        render json: { status: 200, notifications: @notifications }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
    else
      render json: { error: 'Invalid activity type' }, status: :bad_request
    end
  end
end
