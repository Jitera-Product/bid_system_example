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
      notifications = Notification.where(user_id: user_id)
      categorized_notifications = notifications.group_by(&:activity_type)
      render json: { 
        status: :ok,
        total_notifications: notifications.count, 
        total_categories: categorized_notifications.count, 
        notifications: categorized_notifications
      }, status: :ok
    rescue => e
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
end
