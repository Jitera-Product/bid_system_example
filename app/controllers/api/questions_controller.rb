class Api::QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  def index
    @questions = QuestionService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @questions.total_pages
  end
  def show
    authorize @question, policy_class: Api::QuestionsPolicy
  end
  def new
    @question = Question.new
  end
  def edit
  end
  def create
    @question = Question.new(question_params)
    authorize @question, policy_class: Api::QuestionsPolicy
    if @question.valid?
      if @question.save
        render json: { status: 200, question: @question }, status: :created
      else
        render json: { error: 'Internal Server Error' }, status: :internal_server_error
      end
    else
      render json: { error: @question.errors.full_messages }, status: :bad_request
    end
  end
  def update
    authorize @question, policy_class: Api::QuestionsPolicy
    if params[:id].to_i.to_s != params[:id] || params[:user_id].to_i.to_s != params[:user_id]
      render json: { error: 'Wrong format' }, status: :bad_request
    elsif params[:content].blank? || params[:category].blank?
      render json: { error: 'Content and category are required.' }, status: :unprocessable_entity
    else
      if @question.update(question_params)
        render json: { status: 200, question: @question }, status: :ok
      else
        render json: @question.errors, status: :unprocessable_entity
      end
    end
  end
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def retrieve_answer
    query = params[:query]
    context = query.split(' ').map(&:downcase)
    relevant_questions = Question.where('content LIKE ?', "%#{context.join(' ')}%")
    relevant_answers = Answer.where('content LIKE ?', "%#{context.join(' ')}%")
    if relevant_answers.any?
      answer = relevant_answers.first
      render json: {answer: answer.content, question_id: answer.question_id, answer_id: answer.id}
    else
      render json: {error: 'No relevant answers found'}, status: :not_found
    end
  end
  private
  def set_question
    @question = Question.find_by_id(params[:id])
    render json: { error: 'This question is not found' }, status: :not_found unless @question
  end
  def question_params
    params.require(:question).permit(:content, :category, :user_id)
  end
end
