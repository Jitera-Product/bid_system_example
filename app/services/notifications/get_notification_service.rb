# PATH: /app/services/notifications/get_notification_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class Notifications::GetNotificationService
  include Exceptions
  attr_accessor :id
  def initialize(id)
    @id = id
  end
  def execute
    validate_id
    get_notification
  end
  private
  def validate_id
    validator = NotificationValidator.new(id: @id)
    raise InvalidNotificationIdError unless validator.valid?
  end
  def get_notification
    notification = Notification.find_by(id: @id)
    raise NotificationNotFoundError unless notification
    notification
  end
end
# rubocop:enable Style/ClassAndModuleChildren
