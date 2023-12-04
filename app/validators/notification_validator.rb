class NotificationValidator
  include ActiveModel::Validations
  attr_accessor :id
  validates :id, presence: true, numericality: { only_integer: true }
  def initialize(attributes = {})
    @id = attributes[:id]
  end
end
