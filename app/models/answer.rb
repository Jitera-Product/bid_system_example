class Answer < ApplicationRecord
  belongs_to :question

  # validations
  validates :content, presence: true
  validates :question_id, presence: true

  # Add any custom methods below if required

  # Retrieve associated answers for a given question
  def retrieve_associated_answers(question)
    question.answers
  end
end
