class Answer < ApplicationRecord
  belongs_to :question

  # validations
  validates :answer_text, presence: true
  validates :question_id, presence: true, numericality: { only_integer: true }

  # Add any additional methods below this line

  # Retrieve answers for a given question
  def self.find_answers_for_question(question_id)
    where(question_id: question_id)
  end

end
