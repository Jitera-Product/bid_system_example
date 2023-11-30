# PATH: /app/services/question_service/create.rb
# rubocop:disable Style/ClassAndModuleChildren
class QuestionService::Create < BaseService
  include Pundit::Authorization
  attr_accessor :content, :user_id
  def initialize(content, user_id)
    @content = content
    @user_id = user_id
  end
  def call
    validate_user_role
    validate_content
    question = Question.create!(content: content, user_id: user_id)
    { message: 'Question successfully created', id: question.id }
  end
  private
  def validate_user_role
    user = User.find(user_id)
    raise 'User does not have contributor role' unless user.role == 'contributor'
  end
  def validate_content
    raise 'Content cannot be empty' if content.blank?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
