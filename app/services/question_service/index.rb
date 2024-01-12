
class QuestionService
  # existing methods...

  def update_question(question_id, title, content, category, user_id, tags)
    question = Question.find_by(id: question_id)
    return unless question && question.user_id == user_id

    ActiveRecord::Base.transaction do
      question.title = title
      question.content = content
      question.category = category
      question.updated_at = Time.current

      question.update_tags(tags) if tags.present?

      question.save!
    end

    question
  end

end
