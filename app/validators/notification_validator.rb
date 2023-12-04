class NotificationValidator
  include ActiveModel::Validations
  attr_accessor :id, :activity_type
  validates :id, presence: true, numericality: { only_integer: true }
  validate :validate_activity_type
  def initialize(attributes = {})
    @id = attributes[:id]
    @activity_type = attributes[:activity_type]
  end
  def validate_activity_type
    valid_activity_types = ['Bids'] # replace with actual valid activity types
    unless valid_activity_types.include?(@activity_type)
      errors.add(:activity_type, "Invalid activity type.")
    end
  end
end
