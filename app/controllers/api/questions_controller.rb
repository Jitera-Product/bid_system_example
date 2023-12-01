class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  def index
    @questions = QuestionService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @questions.total_pages
  end
  def show
    @question = Question.find_by!('questions.id = ?', params[:id])
    authorize @question, policy_class: Api::QuestionsPolicy
  end
  def create
    @question = Question.new(create_params)
    authorize @question, policy_class: Api::QuestionsPolicy
    return if @question.save
    @error_object = @question.errors.messages
    render status: :unprocessable_entity
  end
  def create_params
    params.require(:questions).permit(:content, :user_id)
  end
  def update
    @question = Question.find_by('questions.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @question.blank? || @question.user_id != params[:user_id].to_i
    authorize @question, policy_class: Api::QuestionsPolicy
    if @question.update(update_params)
      render json: { message: 'Question updated successfully', id: @question.id }, status: :ok
    else
      @error_object = @question.errors.messages
      render status: :unprocessable_entity
    end
  end
  def update_params
    params.require(:questions).permit(:content)
  end
end
