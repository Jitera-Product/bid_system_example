class Api::AnswersController < Api::BaseController
  include AuthenticationConcern
  
  before_action :authenticate_user!, only: [:update, :search] # Ensure user is authenticated for search action as well

  def update
    answer = Answer.find(params[:answer_id])
    authorize answer, :update?

    if AnswerService::Update.new(answer, params[:content]).call
      render json: { message: 'Answer has been updated successfully.' }, status: :ok
    else
      render json: { message: 'Unable to update the answer.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Answer not found.' }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { message: 'You are not authorized to update this answer.' }, status: :forbidden
  rescue StandardError => e
    render json: error_response(nil, e), status: :internal_server_error
  end

  def search
    if params[:query].blank?
      render json: { message: 'The search query cannot be empty.' }, status: :bad_request
      return
    end

    begin
      questions = Question.find_matching_questions(params[:query])
      answers = questions.map { |question| Answer.retrieve_associated_answers(question) }.flatten
      # Updated to match the required response format
      render json: { status: 200, answers: answers.map { |answer| answer.as_json(only: [:id, :content, :question_id, :created_at]) } }, status: :ok
    rescue StandardError => e
      render json: error_response(nil, e), status: :internal_server_error
    end
  end

  # Other controller actions...
end
