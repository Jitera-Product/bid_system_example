class NotificationsService
  def initialize(params = {}, current_user = nil)
    @params = params
    @current_user = current_user
  end
  def get_notifications(user_id)
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    notifications = Notification.where(user_id: user_id)
    categorized_notifications = notifications.group_by(&:activity_type)
    {
      total_notifications: notifications.count,
      total_categories: categorized_notifications.keys.count,
      notifications: categorized_notifications
    }
  end
  def view_notification_details(id)
    notification = find_notification(id)
    notification
  end
  private
  def find_notification(id)
    notification = Notification.find_by(id: id)
    raise ActiveRecord::RecordNotFound, "Couldn't find Notification with 'id'=#{id}" if notification.nil?
    notification
  end
end
