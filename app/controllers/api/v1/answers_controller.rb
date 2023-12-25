class Api::V1::AnswersController < Api::BaseController
  before_action :authenticate_user!, only: [:create]
  before_action :set_answer, only: [:show, :update, :destroy]

  # GET /answers
  def index
    @answers = Answer.all
    render json: @answers
  end

  # GET /answers/1
  def show
    render json: @answer
  end

  # POST /answers
  def create
    begin
      question = Question.find(params[:question_id])
      @answer = question.answers.new(answer_params.merge(user_id: current_user.id))

      if @answer.content.blank?
        render json: { errors: 'Content cannot be empty' }, status: :unprocessable_entity
        return
      end

      if @answer.save
        render json: { id: @answer.id }, status: :created
      else
        render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Question not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :bad_request
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  def destroy
    @answer.destroy
  end

  # POST /answers/retrieve
  def retrieve
    # Assuming NaturalLanguageProcessor and AnswerRetrievalService are already implemented
    question_id = params[:question_id] || NaturalLanguageProcessor.new(params[:query]).interpret
    @answers = Answer.where(question_id: question_id)
    @answer = AnswerRetrievalService.new(@answers).retrieve_most_relevant
    if @answer
      render json: { content: @answer.content }
    else
      render json: { error: 'No relevant answer found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def answer_params
      params.require(:answer).permit(:content).merge(
        question_id: params[:question_id],
        created_at: Time.current,
        updated_at: Time.current
      )
    end
end
