class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create_feedback]
  before_action :authenticate_inquirer, only: [:create_feedback]

  def create_feedback
    validate_feedback_params

    feedback = FeedbackService.new.create_feedback(
      comment: feedback_params[:comment],
      usefulness: feedback_params[:usefulness],
      inquirer_id: current_resource_owner.id,
      answer_id: feedback_params[:answer_id]
    )

    if feedback.persisted?
      render json: { feedback_id: feedback.id }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_inquirer
    # Assuming there's a method to authenticate inquirer similar to user authentication
  end

  def validate_feedback_params
    # Assuming there's a method to validate feedback params similar to user params validation
  end

  def feedback_params
    params.require(:feedback).permit(:comment, :usefulness, :answer_id)
  end
end
