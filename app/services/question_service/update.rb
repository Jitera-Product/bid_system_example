# typed: true
module QuestionService
  class Update < BaseService
    def update(question_id, contributor_id, title, content, tags)
      question = Question.find(question_id)

      if question.user_id != contributor_id
        raise StandardError, 'You are not authorized to update this question.'
      end

      question.update!(title: title, content: content)

      QuestionTag.update_tags(question, tags)

      { message: 'Question updated successfully.' }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    rescue StandardError => e
      { error: e.message }
    end
  end
end
