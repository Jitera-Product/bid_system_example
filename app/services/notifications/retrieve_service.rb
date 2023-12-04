# PATH: /app/services/notifications/retrieve_service.rb
# rubocop:disable Style/ClassAndModuleChildren
module Notifications
  class RetrieveService
    def self.call(user_id)
      raise ArgumentError, 'Wrong format.' unless user_id.is_a? Integer
      notifications = Notification.where(user_id: user_id).group_by(&:activity_type)
      raise ActiveRecord::RecordNotFound, 'No notifications found for this user' if notifications.empty?
      notifications
    rescue ActiveRecord::RecordNotFound => e
      raise e
    rescue ArgumentError => e
      raise e
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
