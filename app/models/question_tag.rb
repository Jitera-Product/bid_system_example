class QuestionTag < ApplicationRecord
  belongs_to :question
  belongs_to :tag

  # validations

  validates :question_id, presence: true
  validates :tag_id, presence: true

  # end for validations

  # Methods
  def self.create_associations(question, tag_ids)
    tag_ids.each do |tag_id|
      create(question_id: question.id, tag_id: tag_id)
    end
  end
  # end for methods
end
