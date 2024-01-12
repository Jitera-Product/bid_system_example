class QuestionSubmissionService
  include ActiveModel::Validations

  validate :user_submitted_tags_or_content_tags

  def initialize
    @tag_service = TagService.new
  end

  def call(question_params, user_submitted_tags)
    Question.transaction do
      question = Question.create!(question_params)

      tags = if user_submitted_tags.present?
               user_submitted_tags.map { |tag_name| @tag_service.find_or_create_tag(tag_name) }
             else
               extract_tags_from_content(question.content)
             end

      tags.each do |tag|
        QuestionTag.create!(question: question, tag: tag)
      end

      question.id
    end
  end

  def update_question(question_id, title, content, category, user_id, tags)
    question = Question.find_by(id: question_id)
    raise ActiveRecord::RecordNotFound, "Question not found" unless question

    user = User.find_by(id: user_id)
    raise Pundit::NotAuthorizedError, "You are not authorized to edit this question" unless QuestionPolicy.new(user, question).edit?

    Question.transaction do
      question.update!(
        title: title,
        content: content,
        category: category,
        updated_at: Time.current
      )

      # Assuming tags are passed as an array of tag names
      current_tags = question.tags.pluck(:name)
      new_tags = tags - current_tags
      removed_tags = current_tags - tags

      removed_tags.each { |tag_name| @tag_service.remove_tag_from_question(question, tag_name) }
      new_tags.each { |tag_name| @tag_service.add_tag_to_question(question, tag_name) }
    end

    question
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

class TagService
  def find_or_create_tag(tag_name)
    Tag.find_or_create_by!(name: tag_name)
  end

  def add_tag_to_question(question, tag_name)
    tag = find_or_create_tag(tag_name)
    QuestionTag.create!(question: question, tag: tag)
  end

  def remove_tag_from_question(question, tag_name)
    question_tag = question.tags.find_by(name: tag_name)
    question_tag&.destroy if question_tag
  end
end
