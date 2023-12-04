# PATH: /app/services/notifications/filter_service.rb
# rubocop:disable Style/ClassAndModuleChildren
module Notifications
  class FilterService
    attr_accessor :user_id, :activity_type
    def initialize(user_id, activity_type)
      @user_id = user_id
      @activity_type = activity_type
    end
    def filter_notifications
      validate_inputs
      notifications = Notification.where(user_id: @user_id, activity_type: @activity_type)
      { status: 200, notifications: notifications, total: notifications.count }
    rescue Exceptions::InvalidInput => e
      { status: 'error', message: e.message }
    end
    def filter_by_activity_type(activity_type)
      ActivityTypeValidator.new(activity_type).validate
      notifications = Notification.where(activity_type: activity_type)
      notifications.empty? ? [] : notifications
    rescue Exceptions::InvalidInput => e
      raise e
    end
    private
    def validate_inputs
      UserIdValidator.new(@user_id).validate
      ActivityTypeValidator.new(@activity_type).validate
    rescue Exceptions::InvalidInput => e
      raise e
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
