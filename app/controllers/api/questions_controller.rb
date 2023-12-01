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
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    authorize @question, policy_class: Api::QuestionsPolicy
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
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
    @question = Question.find(params[:id])
  end
  def question_params
    params.require(:question).permit(:content, :category, :user_id)
  end
end
