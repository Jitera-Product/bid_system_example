# PATH: /app/services/notifications/retrieve_service.rb
# rubocop:disable Style/ClassAndModuleChildren
module Notifications
  class RetrieveService
    def self.call(user_id)
      raise ArgumentError, 'Wrong format.' unless user_id.is_a? Integer
      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordNotFound, 'User not found' unless user
      notifications = Notification.where(user_id: user_id).group_by(&:activity_type)
      raise ActiveRecord::RecordNotFound, 'No notifications found for this user' if notifications.empty?
      total_notifications = notifications.values.flatten.count
      total_categories = notifications.keys.count
      { notifications: notifications, total_notifications: total_notifications, total_categories: total_categories }
    rescue ActiveRecord::RecordNotFound => e
      raise e
    rescue ArgumentError => e
      raise e
    end
    def self.execute(id)
      raise ArgumentError, 'Wrong format.' unless id.is_a? Integer
      notification = Notification.find_by(id: id)
      raise ActiveRecord::RecordNotFound, 'No notification found for this id' if notification.nil?
      notification
    rescue ActiveRecord::RecordNotFound => e
      raise e
    rescue ArgumentError => e
      raise e
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
