# typed: true
module QuestionService
  class Update < BaseService
    class ValidationError < StandardError; end

    def update(question_id:, content:, user_id:)
      raise ValidationError, 'Wrong format.' unless question_id.is_a?(Integer)
      question = Question.find_by(id: question_id)
      raise ValidationError, 'Question not found.' if question.nil?
      raise ValidationError, 'You can only edit your own questions.' unless question.user_id == user_id
      authorize user_id, :update?, question
      raise ValidationError, 'The content of the question cannot be empty.' if content.blank?
      question.content = content
      question.save!
      {
        status: 200,
        question: {
          id: question.id,
          content: question.content,
          user_id: question.user_id,
          updated_at: question.updated_at.iso8601
        }
      }
    end

    private

    def authorize(user_id, policy_method, record)
      raise ValidationError, 'Not authorized' unless QuestionPolicy.new(User.find(user_id), record).public_send(policy_method)
    end
  end
end
