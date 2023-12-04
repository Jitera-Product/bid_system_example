class Notifications::FetchNotificationService
  def execute(notification_id)
    raise ArgumentError, "Wrong format." unless notification_id.is_a? Numeric
    notification = Notification.find_by(id: notification_id)
    raise ActiveRecord::RecordNotFound, "Notification with id #{notification_id} not found" unless notification
    notification
  end
end
