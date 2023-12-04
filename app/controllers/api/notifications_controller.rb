class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!
  def retrieve_notifications
    user_id = params[:user_id]
    if user_id.to_i.to_s != user_id
      render json: { error: 'Wrong format.' }, status: :bad_request
      return
    end
    user = User.find_by(id: user_id)
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end
    begin
      notifications = NotificationService::Index.call(user_id)
      categorized_notifications = notifications.group_by(&:activity_type)
      render json: { 
        status: :ok,
        total_notifications: notifications.count, 
        total_categories: categorized_notifications.count, 
        notifications: notifications.map do |notification|
          {
            id: notification.id,
            user_id: notification.user_id,
            activity_type: notification.activity_type,
            details: notification.details,
            status: notification.status
          }
        end
      }, status: :ok
    rescue => e
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
  def filter_by_activity_type
    activity_type = params[:activity_type]
    activity_type_valid = ActivityTypeValidator.new(activity_type).valid?
    unless activity_type_valid
      render json: { error: 'Invalid activity type.' }, status: :bad_request
      return
    end
    begin
      notifications = Notification.where(activity_type: activity_type)
      render json: { 
        status: 200,
        total_notifications: notifications.count, 
        notifications: notifications.map do |notification|
          {
            id: notification.id,
            user_id: notification.user_id,
            activity_type: notification.activity_type,
            details: notification.details,
            status: notification.status
          }
        end
      }, status: :ok
    rescue => e
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
  def show
    id = params[:id].to_i
    return render json: { error: 'Wrong format.' }, status: :bad_request unless id.is_a?(Integer)
    notification = Notification.find_by(id: id)
    if notification.nil?
      render json: { error: 'Notification not found' }, status: :not_found
    else
      render json: { status: 200, notification: notification }, status: :ok
    end
  rescue => e
    render json: { error: 'Unexpected error occurred.' }, status: :internal_server_error
  end
end
