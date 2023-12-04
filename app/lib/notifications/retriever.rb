class Retriever
  # Other methods...
  def retrieve_notification(id)
    notification = Notification.find_by(id: id)
    raise "Notification not found" if notification.nil?
    notification
  rescue ActiveRecord::RecordNotFound => e
    raise "Notification not found"
  end
end
