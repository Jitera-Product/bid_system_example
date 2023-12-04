class ActivityTypeValidator < ActiveModel::Validator
  def validate(record)
    unless Notification.activity_types.include?(record.activity_type)
      record.errors.add(:activity_type, "Invalid activity_type.")
    end
  end
end
