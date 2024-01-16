class Answer < ApplicationRecord
  belongs_to :question

  # validations
  validates :content, presence: true
  validates :question_id, presence: true

  has_many :feedbacks, dependent: :destroy

  # Retrieve associated answers for a given question
  def self.retrieve_associated_answers(question)
    question.answers
  end

  # Add any custom methods below if required
end
