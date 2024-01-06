class Api::FeedbacksController < ApplicationController
  before_action :authenticate_inquirer!

  def create
    if Answer.exists?(feedback_params[:answer_id])
      feedback = Feedback.new(feedback_params.merge(created_at: Time.current))
      if feedback.save
        # Logic to adjust AI's future responses based on feedback
        # This could be a service call or background job
        # Example: AiAdjustmentService.new(feedback).perform

        render json: { id: feedback.id, message: 'Feedback submitted successfully', metadata: feedback_metadata(feedback) }, status: :created
      else
        render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Answer not found' }, status: :not_found
    end
  end

  private

  def authenticate_inquirer!
    head :unauthorized unless current_user&.role == 'Inquirer'
  end

  def feedback_params
    params.permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end
end
