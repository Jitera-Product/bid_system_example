class QuestionTagAssociation < ApplicationRecord
  # relationships
  belongs_to :tag
  belongs_to :question

  # validations
  validates :tag_id, presence: true
  validates :question_id, presence: true
end
