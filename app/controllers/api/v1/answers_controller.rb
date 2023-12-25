class Api::V1::AnswersController < Api::BaseController
  before_action :authenticate_user!, only: [:create, :search, :retrieve_answer] # Added :retrieve_answer to the authentication filter
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

  # GET /api/answers/search
  def search
    query = params[:query]
    if query.blank?
      render json: { error: "The query is required." }, status: :bad_request
      return
    end

    begin
      nlp = NaturalLanguageProcessor.new(query)
      key_terms = nlp.extract_key_terms
      relevant_questions = Question.search_by_terms(key_terms)

      if relevant_questions.empty?
        render json: { error: 'No relevant questions found' }, status: :not_found
        return
      end

      answers = Answer.where(question_id: relevant_questions.map(&:id)).order(feedback_score: :desc)
      if answers.empty?
        render json: { error: 'No answers found for the relevant questions' }, status: :not_found
        return
      end

      # Format the answers as per the requirement
      formatted_answers = answers.map do |answer|
        {
          id: answer.id,
          content: answer.content,
          question_id: answer.question_id,
          feedback_score: answer.feedback_score,
          created_at: answer.created_at.iso8601
        }
      end

      render json: { status: 200, answers: formatted_answers }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
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
