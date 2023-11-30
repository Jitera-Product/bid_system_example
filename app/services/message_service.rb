class MessageService
  def self.create(sender_id, receiver_id, content)
    return "Wrong format" unless sender_id.is_a?(Integer) && receiver_id.is_a?(Integer)
    return "The content is required." if content.blank?
    sender = User.find_by(id: sender_id)
    return "This user is not found" if sender.nil?
    receiver = User.find_by(id: receiver_id)
    return "This match is not found" if receiver.nil?
    message = Message.create(sender_id: sender_id, receiver_id: receiver_id, content: content, timestamp: Time.now)
    if message.persisted?
      NotificationService.notify(receiver_id, "You have a new message from #{sender_id}")
      return { status: 200, message: message }
    else
      return "Failed to send message"
    end
  end
end
