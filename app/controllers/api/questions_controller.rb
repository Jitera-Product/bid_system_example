class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update edit]
  before_action :set_user, only: [:create]
  def index
    @questions = QuestionService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @questions.total_pages
  end
  def show
    @question = Question.find_by!('questions.id = ?', params[:id])
  end
  def create
    @question = @user.questions.new(question_params)
    authorize @question, policy_class: Api::QuestionsPolicy
    if @question.save
      render json: {message: "Question submitted successfully", question_id: @question.id}, status: :created
    else
      @error_object = @question.errors.messages
      render status: :unprocessable_entity
    end
  end
  def update
    @question = Question.find_by('questions.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @question.blank?
    authorize @question, policy_class: Api::QuestionsPolicy
    return if @question.update(update_params)
    @error_object = @question.errors.messages
    render status: :unprocessable_entity
  end
  def edit
    @question = Question.find_by('questions.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @question.blank?
    authorize @question, policy_class: Api::QuestionsPolicy
    return if @question.update(edit_params)
    flash[:notice] = "Question was successfully updated."
    render json: { id: @question.id }, status: :ok
  end
  private
  def set_user
    @user = User.find_by_id(params[:question][:contributor_id])
    render json: {error: "User not found"}, status: :not_found unless @user
  end
  def question_params
    params.require(:question).permit(:content, :tags, :contributor_id)
  end
  def update_params
    params.require(:questions).permit(:content, :tags, :user_id)
  end
  def edit_params
    params.require(:questions).permit(:content, :tags, :contributor_id)
  end
end
