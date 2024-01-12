class QuestionTag < ApplicationRecord
  belongs_to :question
  belongs_to :tag

  validates :question_id, presence: true
  validates :tag_id, presence: true

  # Additional logic related to QuestionTag can be placed here
end

