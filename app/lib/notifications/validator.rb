class Validator
  # Other methods...
  def validate_id(id)
    unless Notification.exists?(id)
      raise StandardError.new("Notification with id #{id} does not exist")
    end
  end
end
