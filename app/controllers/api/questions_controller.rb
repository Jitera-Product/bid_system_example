class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update moderate]
  before_action :find_question_or_answer, only: [:moderate]
  before_action :authorize_admin, only: [:moderate]
  before_action :authorize_contributor, only: [:create]
  # other methods...
  def create
    question = Question.new(question_params)
    if question.save
      render json: { status: 200, question: question }, status: :ok
    else
      render json: { message: 'Internal Server Error' }, status: :internal_server_error
    end
  end
  def moderate
    if @resource.update(moderate_params)
      render json: { message: 'Content has been moderated successfully.', id: @resource.id }, status: :ok
    else
      @error_object = @resource.errors.messages
      render status: :unprocessable_entity
    end
  end
  private
  def question_params
    params.require(:question).permit(:content, :user_id).tap do |whitelisted|
      raise 'The question content is required.' if whitelisted[:content].blank?
      raise 'Wrong format.' unless whitelisted[:user_id].is_a?(Integer)
    end
  end
  def moderate_params
    params.require(:moderate).permit(:content)
  end
  def find_question_or_answer
    @resource = Question.find_by(id: params[:question_id]) || Answer.find_by(id: params[:answer_id])
    raise ActiveRecord::RecordNotFound if @resource.blank?
  end
  def authorize_admin
    user = User.find(params[:user_id])
    raise ActiveRecord::RecordNotFound if user.blank?
    raise 'Unauthorized' unless user.admin?
  end
  def authorize_contributor
    user = User.find(params[:user_id])
    raise ActiveRecord::RecordNotFound if user.blank?
    raise 'Forbidden' unless user.contributor?
  end
end
