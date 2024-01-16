require_relative '../../services/answer_submission_service'
require_relative '../../policies/answer_policy'

module Api
  class AnswersController < Api::BaseController
    include AuthenticationConcern

    before_action :authenticate_user!, only: [:create, :update, :search]

    def create
      content = params[:content]
      question_id = params[:question_id]

      if content.blank?
        render json: { error: 'The content of the answer cannot be empty.' }, status: :bad_request
        return
      elsif question_id.blank?
        render json: { error: 'Question not found.' }, status: :bad_request
        return
      end

      begin
        answer_id = AnswerSubmissionService.new.submit_answer(content: content, question_id: question_id, user_id: current_user.id)
        answer = Answer.find(answer_id)
        render json: { status: 201, answer: answer.as_json.merge(created_at: answer.created_at.iso8601) }, status: :created
      rescue Pundit::NotAuthorizedError
        render json: { error: 'Not authorized to create an answer' }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound, ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

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
        render json: { status: 200, answers: answers.map { |answer| answer.as_json(only: [:id, :content, :question_id, :created_at]) } }, status: :ok
      rescue StandardError => e
        render json: error_response(nil, e), status: :internal_server_error
      end
    end

    # Other controller actions...
  end
end
