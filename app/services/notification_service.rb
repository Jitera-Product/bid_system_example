class NotificationService
  def initialize(user, activity_type)
    @user = user
    @activity_type = activity_type
  end
  def send_notification(message)
    Notification.create(user_id: @user.id, details: message, status: 'unread', activity_type: 'system')
  end
  def filter_by_category
    notifications = Notification.where(user_id: @user.id, activity_type: @activity_type)
    { status: 200, notifications: notifications }
  end
end
