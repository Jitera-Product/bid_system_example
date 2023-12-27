class Answer < ApplicationRecord
  belongs_to :question

  # validations

  validates :content, presence: true
  validates :question_id, presence: true

  # end for validations
end
