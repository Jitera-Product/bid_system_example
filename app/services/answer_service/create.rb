# PATH: /app/services/answer_service/create.rb
# rubocop:disable Style/ClassAndModuleChildren
class AnswerService::Create
  attr_accessor :content, :question_id, :user_id
  def initialize(content, question_id, user_id)
    @content = content
    @question_id = question_id
    @user_id = user_id
  end
  def execute
    user = User.find(user_id)
    raise 'User is not a contributor' unless user.role == 'contributor'
    question = Question.find(question_id)
    raise 'Question does not exist' unless question
    raise 'Content cannot be empty' if content.blank?
    answer = Answer.create(content: content, question_id: question_id, user_id: user_id)
    if answer.persisted?
      { message: 'Answer submitted successfully', id: answer.id }
    else
      { message: answer.errors.full_messages.join(', ') }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
