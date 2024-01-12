class QuestionValidator
  include ActiveModel::Model

  attr_accessor :title, :content, :category, :tags, :id

  # Combining the validation rules for :title from both versions
  validates :title, presence: { message: "The title is required." }, length: { minimum: 5, maximum: 200, too_long: "You cannot input more than 200 characters." }
  validates :content, presence: { message: "The content is required." }
  validates :category, presence: { message: "The category is required." }, inclusion: { in: %w(Technology Health Business) }

  # Combining the validation rules for :tags from both versions
  validate :tags_must_be_an_array_of_integers

  # Adding the new validation for :id from the new code
  validate :validate_id_format, if: :id_present?

  def validate_question_params
    validate!
  rescue ActiveModel::ValidationError => e
    e.full_messages
  end

  private

  # Combining the tags validation methods from both versions
  def tags_must_be_an_array_of_integers
    unless tags.is_a?(Array) && tags.all? { |tag| tag.is_a?(Integer) }
      errors.add(:tags, "Tags must be an array of tag IDs.")
    end
  end

  # Methods from the new code for validating :id
  def validate_id_format
    errors.add(:id, "Wrong format.") unless id.is_a?(Integer)
  end

  def id_present?
    id.present?
  end
end

def update(question_params)
  question_validator = QuestionValidator.new(question_params)
  question_validator.validate_question_params
end
