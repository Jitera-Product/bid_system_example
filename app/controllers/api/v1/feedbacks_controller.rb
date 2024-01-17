class Api::V1::FeedbacksController < ApplicationController
  include OauthTokensConcern
  before_action :doorkeeper_authorize!
  before_action :authenticate_inquirer!

  def create
    feedback_params = params.permit(:answer_id, :user_id, :comment, :usefulness)
    validate_feedback_params(feedback_params)
    feedback = Feedback.create!(feedback_params)
    FeedbackService.update_ai_response_accuracy(feedback)
    render json: { message: 'Your feedback has been recorded.' }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue InvalidAnswerIdError, InvalidUsefulnessValueError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def authenticate_inquirer!
    raise Pundit::NotAuthorizedError unless current_user.inquirer?
  end
end
