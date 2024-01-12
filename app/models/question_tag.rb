
class QuestionTag < ApplicationRecord
  belongs_to :question
  belongs_to :tag

  def self.update_tags_for_question(question, tag_ids)
    transaction do
      question.question_tags.destroy_all
      tag_ids.each do |tag_id|
        create!(question_id: question.id, tag_id: tag_id)
      end
    end
  rescue => e
    Rails.logger.error "Failed to update tags for question: #{e.message}"
  end
  # existing code
end
