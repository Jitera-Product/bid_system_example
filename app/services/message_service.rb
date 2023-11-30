class MessageService
  def self.create(sender_id, receiver_id, content)
    message = Message.create(sender_id: sender_id, receiver_id: receiver_id, content: content, timestamp: Time.now)
    if message.persisted?
      NotificationService.notify(receiver_id, "You have a new message from #{sender_id}")
      return "Message sent successfully"
    else
      return "Failed to send message"
    end
  end
end
