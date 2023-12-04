# PATH: /app/services/notification_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class NotificationService::Index
  attr_accessor :user_id, :notifications, :categories
  def initialize(user_id)
    @user_id = user_id
  end
  def retrieve_notifications
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
  end
end
# rubocop:enable Style/ClassAndModuleChildren
