class Question < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :question_categories, dependent: :destroy

  # Validations
  validates :content, presence: true, length: { minimum: 10 }
  validates :user_id, presence: true

  # Custom methods
  def self.update_question(id, content, user_id)
    question = Question.find_by(id: id, user_id: user_id)
    return 'Question not found or not owned by user' unless question

    if question.update(content: content)
      'Question updated successfully'
    else
      question.errors.full_messages.to_sentence
    end
  end
end
