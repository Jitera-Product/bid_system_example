class NotificationJob < ApplicationJob
  queue_as :default
  def perform(receiver_id)
    UserMailer.notification_email(User.find(receiver_id)).deliver_later
  end
end
