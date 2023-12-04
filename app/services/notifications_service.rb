class NotificationsService
  def initialize; end
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
end
