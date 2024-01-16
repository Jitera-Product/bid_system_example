# typed: true
module QuestionService
  class Update < BaseService
    class ValidationError < StandardError; end

    def update(question_id:, content:, user_id:, tags:)
      question = Question.find(question_id)
      authorize user_id, :update?, question
      raise ValidationError, 'Content cannot be empty' if content.blank?
      raise ValidationError, 'Invalid tags' unless Tag.where(id: tags).count == tags.size
      question.content = content
      question.question_tags = tags.map { |tag_id| QuestionTag.new(tag_id: tag_id) }
      question.save!
      { message: 'Question updated successfully' }
    end

    private

    def authorize(user_id, policy_method, record)
      raise ValidationError, 'Not authorized' unless QuestionPolicy.new(User.find(user_id), record).public_send(policy_method)
    end
  end
end
