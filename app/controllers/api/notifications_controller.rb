class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!
  def retrieve_notifications
    user_id = params[:user_id]
    user = User.find_by(id: user_id)
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end
    notifications = Notification.where(user_id: user_id)
    categorized_notifications = notifications.group_by(&:activity_type)
    render json: { 
      total_notifications: notifications.count, 
      total_categories: categorized_notifications.count, 
      notifications: categorized_notifications 
    }, status: :ok
  end
end
