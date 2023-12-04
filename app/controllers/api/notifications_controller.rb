class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update filter_by_category get_notifications]
  def index
    @notifications = NotificationService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @notifications.total_pages
  end
  def show
    @notification = Notification.find_by!('notifications.id = ?', params[:id])
    authorize @notification, policy_class: Api::NotificationsPolicy
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
    begin
      user = User.find(params[:user_id])
      activity_type = params[:activity_type]
      @notifications = Notification.where(user_id: user.id, activity_type: activity_type)
      render json: { notifications: @notifications, total: @notifications.count }
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User or Activity Type not found' }, status: :not_found
    end
  end
  def get_notifications
    user = User.find_by(id: params[:user_id])
    return render json: { error: 'User not found' }, status: :not_found unless user
    notifications = Notification.where(user_id: user.id)
    categorized_notifications = notifications.group_by(&:activity_type)
    render json: {
      total_notifications: notifications.count,
      total_categories: categorized_notifications.count,
      notifications: categorized_notifications
    }, status: :ok
  end
end
