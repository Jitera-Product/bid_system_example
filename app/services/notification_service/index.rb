class NotificationService
  # Other methods...
  def send_kyc_status_notification(user, message)
    puts "Sending notification to #{user.email}: #{message}"
    return "Notification sent successfully"
  end
  def handle_kyc_timeout(user)
    user.update_kyc_status('Incomplete')
    message = "Your KYC status has been updated to 'Incomplete'. Certain features may be restricted until you complete the KYC process."
    send_kyc_status_notification(user, message)
  end
end
