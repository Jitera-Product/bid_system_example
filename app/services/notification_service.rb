class NotificationService
  def send_notification(receiver_id)
    NotificationJob.perform_later(receiver_id)
  end
end
