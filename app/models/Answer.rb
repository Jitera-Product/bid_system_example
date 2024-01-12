class Answer < ApplicationRecord
  # associations
  belongs_to :question

  # validations
  validates :content, presence: true
  validates :question_id, presence: true

  # custom methods
end
