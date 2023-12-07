# /app/services/notification_service/index.rb

class NotificationService
  def self.send_notification(user_id, content)
    # Check if the user exists and is eligible to receive notifications
    return { success: false, message: 'User does not exist.' } unless User.exists?(user_id)

    begin
      # Create a new Notification record
      notification = Notification.create!(user_id: user_id, content: content, created_at: Time.current)

      # Send the notification to the user's device
      # This is a placeholder for the actual notification sending logic, which could be an API call or using a library
      # For example: NotificationSender.send(notification)
      # Assuming NotificationSender is a hypothetical external service or library

      # Log the successful delivery
      Rails.logger.info("Notification sent successfully to user #{user_id}")

      { success: true, message: 'Notification sent successfully.' }
    rescue => e
      # Log the error
      Rails.logger.error("Failed to send notification to user #{user_id}: #{e.message}")

      { success: false, message: 'Notification failed to send.' }
    end
  end
end
