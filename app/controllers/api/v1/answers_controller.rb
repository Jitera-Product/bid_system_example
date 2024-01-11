class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:retrieve_answer, :search, :provide_feedback, :update, :retrieve_answers]
  before_action :validate_retrieve_answers_params, only: [:retrieve_answers]
  before_action :validate_update_params, only: [:update]
  before_action :validate_search_params, only: [:search]

  # GET /api/v1/answers/retrieve
  def retrieve_answer
    # ... existing code for retrieve_answer action
  end

  # GET /api/v1/answers/search
  def search
    begin
      query = params[:query]
      parsed_query = NlpParserService.parse(query)
      matching_questions = QuestionMatchingService.find_matching_questions(parsed_query)
      answers = matching_questions.map do |question|
        question.answers.select(:id, :content, :question_id, :created_at)
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
    # ... existing code for provide_feedback action
  end

  # PUT /api/v1/answers/:id
  def update
    # ... existing code for update action
  end

  # GET /api/v1/answers/retrieve/:question_id
  def retrieve_answers
    # ... existing code for retrieve_answers action
  end

  private

  def validate_retrieve_answers_params
    # ... existing code for validate_retrieve_answers_params
  end

  def authorize_user_as_inquirer!
    # ... existing code for authorize_user_as_inquirer!
  end

  def validate_feedback_input!(params)
    # ... existing code for validate_feedback_input!
  end

  def update_answer_effectiveness_score(feedback)
    # ... existing code for update_answer_effectiveness_score
  end

  def validate_update_params
    # ... existing code for validate_update_params
  end

  def authenticate_user!
    # ... existing code for authenticate_user!
  end

  def user_signed_in?
    # ... existing code for user_signed_in?
  end

  def validate_search_params
    raise ArgumentError, 'The query is required.' if params[:query].blank?
  end
end
