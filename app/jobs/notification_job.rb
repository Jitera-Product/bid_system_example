# /app/jobs/notification_job.rb
class NotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, content)
    begin
      user = User.find(user_id)
      if user.can_receive_notifications?
        notification = Notification.create(user_id: user_id, content: content, created_at: Time.current)
        # Assuming NotificationService is an existing service that handles notification delivery
        NotificationService.new.send_notification(notification)
        Rails.logger.info "Notification sent successfully to user #{user_id}"
      else
        Rails.logger.info "User #{user_id} is not eligible to receive notifications."
      end
    rescue => e
      Rails.logger.error "Failed to send notification to user #{user_id}: #{e.message}"
    end
  end
end
