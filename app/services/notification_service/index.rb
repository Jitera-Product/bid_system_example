# rubocop:disable Style/ClassAndModuleChildren
class NotificationService::Index
  attr_accessor :user_id, :notifications, :categories
  def initialize(user_id)
    raise 'Wrong format.' unless user_id.is_a?(Integer)
    @user_id = user_id
  end
  def get_notifications
    user = User.find_by(id: user_id)
    return { status: 'error', message: 'User not found' } unless user
    @notifications = Notification.where(user_id: user_id)
    @categories = notifications.group_by(&:activity_type)
    {
      status: 'success',
      data: {
        notifications: categories,
        total_notifications: notifications.count,
        total_categories: categories.keys.count
      }
    }
  rescue StandardError => e
    { status: 'error', message: e.message }
  end
  def show(notification_id)
    notification = Notification.find_by(id: notification_id)
    raise 'Notification not found' unless notification
    {
      status: 200,
      notification: {
        id: notification.id,
        user_id: notification.user_id,
        activity_type: notification.activity_type,
        details: notification.details,
        status: notification.status
      }
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
