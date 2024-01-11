
class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:retrieve_answer, :search, :update]
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

  private

  def validate_update_params
    raise ArgumentError, 'Answer ID and content are required.' if params[:answer_id].blank? || params[:content].blank?
  end

  def authenticate_user!
    # Authentication logic here, raise Exceptions::AuthenticationError if failed
  end
end
