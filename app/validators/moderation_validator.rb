class ModerationValidator
  include ActiveModel::Model

  attr_accessor :type, :id, :status

  validates :type, inclusion: { in: %w(question answer), message: "Type must be either 'question' or 'answer'." }
  validates :id, numericality: { only_integer: true, message: "Wrong format." }, presence: true
  validate :record_exists
  validates :status, inclusion: { in: %w(approved rejected pending), message: "Invalid status value." }

  def validate_moderation_params
    validate!
  rescue ActiveModel::ValidationError => e
    e.full_messages
  end

  private

  def record_exists
    klass = type.capitalize.constantize
    errors.add(:id, "The specified content is not found.") unless klass.exists?(id)
  end
end
