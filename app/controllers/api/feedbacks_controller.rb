class Api::FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def create
    # Validate that the answer_id is a number
    unless feedback_params[:answer_id].to_s.match?(/\A[0-9]+\z/)
      return render json: { error: 'Answer ID must be a number.' }, status: :bad_request
    end

    # Validate that the usefulness is a valid enum value
    unless ['helpful', 'not_helpful'].include?(feedback_params[:usefulness])
      return render json: { error: 'Invalid value for usefulness.' }, status: :unprocessable_entity
    end

    feedback_service = FeedbackService.new(feedback_params, current_user)
    result = feedback_service.call

    if result[:error].present?
      render json: { error: result[:error] }, status: result[:status]
    else
      feedback = result[:feedback]
      render json: {
        status: 201,
        feedback: {
          id: feedback.id,
          answer_id: feedback.answer_id,
          user_id: feedback.user_id,
          usefulness: feedback.usefulness,
          created_at: feedback.created_at.iso8601
        }
      }, status: :created
    end
  end

  private

  def authenticate_user!
    head :unauthorized unless current_user&.role == 'Inquirer' || current_user&.role == 'User'
  end

  def feedback_params
    params.require(:feedback).permit(:answer_id, :usefulness)
  end
end
