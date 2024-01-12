
class QuestionSubmissionService
  include ActiveModel::Validations

  validate :user_submitted_tags_or_content_tags

  def call(question_params, user_submitted_tags)
    Question.transaction do
      question = Question.create!(question_params)

      tags = if user_submitted_tags.present?
               user_submitted_tags.map { |tag_name| Tag.find_or_create_by!(name: tag_name) }
             else
               extract_tags_from_content(question.content)
             end

      tags.each do |tag|
        QuestionTag.create!(question: question, tag: tag)
      end

      question.id
    end
  end

  private

  def extract_tags_from_content(content)
    # Placeholder for tag extraction logic
    []
  end

  def user_submitted_tags_or_content_tags
    # Placeholder for validation logic
  end
end
