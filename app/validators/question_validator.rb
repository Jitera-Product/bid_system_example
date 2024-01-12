class QuestionValidator
  include ActiveModel::Model

  attr_accessor :title, :content, :category

  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: %w(Technology Health Business) }

  def validate_question_params
    validate!
  rescue ActiveModel::ValidationError => e
    e.full_messages
  end
end

def update(question_params)
  question_validator = QuestionValidator.new(question_params)
  question_validator.validate_question_params
end
