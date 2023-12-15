class QuestionTag < ApplicationRecord
  belongs_to :question
  belongs_to :tag

  # validations

  validates :question_id, presence: true
  validates :tag_id, presence: true

  # Add new column 'tag' to the model
  validates :tag, presence: true

  # end for validations
end
