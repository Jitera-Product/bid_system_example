class QuestionTag < ApplicationRecord
  # relationships
  belongs_to :question
  belongs_to :tag

  # validations
  validates :question_id, presence: true
  validates :tag_id, presence: true
end
