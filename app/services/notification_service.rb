class NotificationService
  def get_notification(id)
    Notification.find(id)
  rescue ActiveRecord::RecordNotFound
    { error: 'Notification not found' }
  end
end
