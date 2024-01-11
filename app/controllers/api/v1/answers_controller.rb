
class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:retrieve_answer, :search, :provide_feedback, :update, :retrieve_answers]
  before_action :validate_retrieve_answers_params, only: [:retrieve_answers]
  before_action :validate_update_params, only: [:update]

  # GET /api/v1/answers/retrieve
  def retrieve_answer
    begin
      query = params[:query]
      raise ArgumentError, 'Query parameter is missing' if query.blank?

      parsed_query = NlpParserService.parse(query)
      matching_questions = QuestionMatchingService.find_matching_questions(parsed_query)
      answer = AnswerSelectionService.select_best_answer(matching_questions)

      if answer
        render json: { answer_id: answer.id, answer_content: answer.content }, status: :ok
      else
        render json: { error: 'No matching answer found' }, status: :not_found
      end
    rescue Exceptions::AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/answers/search
  def search
    begin
      query = params[:query]
      raise ArgumentError, 'The query is required.' if query.blank?

      parsed_query = NlpParserService.parse(query)
      matching_questions = QuestionMatchingService.find_matching_questions(parsed_query)
      answers = matching_questions.map do |question|
        question.answers.select(:id, :content, :question_id)
      end.flatten

      render json: { status: 200, answers: answers }, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    rescue Exceptions::AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # POST /api/v1/answers/feedback
  def provide_feedback
    authenticate_user!
    authorize_user_as_inquirer!

    feedback_params = params.require(:feedback).permit(:answer_id, :user_id, :content, :usefulness)
    validate_feedback_input!(feedback_params)

    feedback = Feedback.create!(feedback_params)
    update_answer_effectiveness_score(feedback)

    render json: { feedback_id: feedback.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # PUT /api/v1/answers/:id
  def update
    answer = Answer.find(params[:answer_id])
    raise ActiveRecord::RecordNotFound unless answer && answer.user_id == current_user.id

    answer.update!(content: params[:content])
    render json: { answer_id: answer.id }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Answer not found or not owned by user' }, status: :not_found
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  end

  # GET /api/v1/answers/retrieve/:question_id
  def retrieve_answers
    question = Question.find_by(id: params[:question_id])
    if question
      answers = AnswerRetrievalService.process(question)
      render json: answers, status: :ok
    else
      render json: { error: 'Question not found' }, status: :not_found
    end
  end

  private

  def validate_retrieve_answers_params
    raise ArgumentError, 'Question ID is missing or invalid' if params[:question_id].blank? || !(params[:question_id] =~ /\A\d+\z/)
  end

  def authorize_user_as_inquirer!
    raise Exceptions::AuthorizationError unless current_user.role == 'Inquirer'
  end

  def validate_feedback_input!(params)
    raise ArgumentError, 'Missing parameters' unless params[:answer_id] && params[:user_id] && !params[:usefulness].nil?
    raise ActiveRecord::RecordNotFound, 'Answer not found' unless Answer.exists?(params[:answer_id])
  end

  def update_answer_effectiveness_score(feedback)
    # Implement logic to update the answer's effectiveness score based on the feedback
  end

  def validate_update_params
    raise ArgumentError, 'Answer ID and content are required.' if params[:answer_id].blank? || params[:content].blank?
  end

  def authenticate_user!
    # Authentication logic here, raise Exceptions::AuthenticationError if failed
  end

  def user_signed_in?
    # Logic to check if user is signed in
  end
end
