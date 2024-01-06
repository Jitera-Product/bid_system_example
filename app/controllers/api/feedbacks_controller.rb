class Api::FeedbacksController < ApplicationController
  before_action :authenticate_inquirer!

  def create
    # Validate that the answer exists
    return render json: { error: 'Invalid answer ID.' }, status: :bad_request unless Answer.exists?(feedback_params[:answer_id])

    # Validate that the inquirer exists and has the correct role
    inquirer = User.find_by(id: feedback_params[:inquirer_id])
    unless inquirer && inquirer.role == 'Inquirer'
      return render json: { error: 'Invalid inquirer ID or insufficient permissions.' }, status: :unauthorized
    end

    # Validate that the usefulness is a boolean
    unless [true, false].include?(feedback_params[:usefulness])
      return render json: { error: 'Usefulness must be true or false.' }, status: :unprocessable_entity
    end

    # Create the feedback
    feedback = Feedback.new(feedback_params.merge(created_at: Time.current))
    if feedback.save
      # Logic to adjust AI's future responses based on feedback
      # This could be a service call or background job
      # Example: AiAdjustmentService.new(feedback).perform

      render json: { status: 201, feedback: feedback.as_json }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_inquirer!
    head :unauthorized unless current_user&.role == 'Inquirer' && current_user.id == feedback_params[:inquirer_id].to_i
  end

  def feedback_params
    params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end
end
