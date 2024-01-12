class QuestionValidator
  include ActiveModel::Model

  attr_accessor :title, :content, :category, :tags

  validates :title, presence: { message: "The title is required." }, length: { minimum: 5, maximum: 255 }
  validates :content, presence: { message: "The content is required." }
  validates :category, presence: { message: "The category is required." }, inclusion: { in: %w(Technology Health Business) }
  validate :tags_must_be_an_array_of_integers

  def validate_question_params
    validate!
  rescue ActiveModel::ValidationError => e
    e.full_messages
  end

  private

  def tags_must_be_an_array_of_integers
    unless tags.is_a?(Array) && tags.all? { |tag| tag.is_a?(Integer) }
      errors.add(:tags, "Tags must be an array of tag IDs.")
    end
  end
end

def update(question_params)
  question_validator = QuestionValidator.new(question_params)
  question_validator.validate_question_params
end
