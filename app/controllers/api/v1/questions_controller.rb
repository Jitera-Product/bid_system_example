
class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:update]
  before_action :authorize_update, only: [:update]

  def update
    result = QuestionService::Update.new(
      question_id: @question.id,
      content: params[:content],
      user_id: current_user.id,
      tags: params[:tags]
    ).call
    render json: result, status: :ok
  rescue Exceptions::AuthenticationError, Pundit::NotAuthorizedError
    render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Question not found' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def authorize_update
    authorize @question, :update?
  end
end
