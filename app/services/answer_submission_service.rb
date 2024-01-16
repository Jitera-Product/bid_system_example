class AnswerSubmissionService
  def submit_answer(content:, question_id:, user_id:)
    user = User.find(user_id)
    raise Pundit::NotAuthorizedError unless AnswerPolicy.new(user).create?

    raise ArgumentError, 'Content cannot be blank' if content.blank?
    raise ActiveRecord::RecordNotFound, 'Question does not exist' unless Question.exists?(question_id)

    answer = Answer.create!(content: content, question_id: question_id, user_id: user_id)
    answer.id
  end
end
