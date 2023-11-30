class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    user = User.find_by(id: params[:user_id])
    return render json: { error: 'User not found or not a contributor' }, status: :unprocessable_entity unless user&.role == 'contributor'
    question = Question.new(question_params.merge(user_id: user.id))
    if question.save
      render json: { message: 'Question successfully created', question_id: question.id }, status: :created
    else
      render json: { error: question.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def question_params
    params.require(:question).permit(:content, :category)
  end
end
