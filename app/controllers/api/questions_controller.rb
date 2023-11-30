class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update edit moderate_content retrieve_answer]
  before_action :set_user, only: [:create, :moderate_content]
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
    if @question.update(update_params)
      render json: {message: "Question updated successfully", question_id: @question.id}, status: :ok
    else
      @error_object = @question.errors.messages
      render status: :unprocessable_entity
    end
  end
  def edit
    @question = Question.find_by('questions.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @question.blank?
    authorize @question, policy_class: Api::QuestionsPolicy
    if @question.update(edit_params)
      flash[:notice] = "Question was successfully updated."
      render json: { id: @question.id }, status: :ok
    else
      @error_object = @question.errors.messages
      render status: :unprocessable_entity
    end
  end
  def moderate_content
    begin
      @content = Question.find_by(id: params[:id]) || Answer.find_by(id: params[:id])
      raise ActiveRecord::RecordNotFound if @content.blank?
      raise ActiveRecord::RecordNotFound if @user.blank?
      if @content.update(content: params[:content])
        render json: {message: "Content moderated successfully", content_id: @content.id}, status: :ok
      else
        @error_object = @content.errors.messages
        render json: {error: @error_object}, status: :unprocessable_entity
      end
    rescue => e
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end
  def retrieve_answer
    query = params[:query]
    questions = Question.where("content LIKE ?", "%#{query}%")
    answers = Answer.where("content LIKE ?", "%#{query}%")
    relevant_answers = answers.select { |answer| questions.map(&:id).include?(answer.question_id) }
    most_relevant_answer = relevant_answers.max_by { |answer| answer.created_at }
    if most_relevant_answer
      render json: {answer_content: most_relevant_answer.content, question_id: most_relevant_answer.question_id, answer_id: most_relevant_answer.id}
    else
      render json: {message: "No relevant answer found"}, status: :not_found
    end
  end
  private
  def set_user
    @user = User.find_by_id(params[:contributor_id] || params[:question][:contributor_id])
    render json: {error: "User not found"}, status: :not_found unless @user
  end
  def question_params
    params.require(:question).permit(:content, :tags, :contributor_id)
  end
  def update_params
    params.require(:question).permit(:content, :tags, :user_id)
  end
  def edit_params
    params.require(:question).permit(:content, :tags, :contributor_id)
  end
end
