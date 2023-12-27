class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]

  def create
    # Ensure the answer exists
    answer = Answer.find_by(id: feedback_params[:answer_id])
    return render json: { error: 'Answer not found' }, status: :not_found unless answer

    # Ensure the inquirer exists and has the correct role
    inquirer = User.find_by(id: feedback_params[:inquirer_id])
    unless inquirer&.role == 'Inquirer'
      return render json: { error: 'Inquirer not found or not valid' }, status: :forbidden
    end

    # Create the feedback
    feedback = Feedback.new(feedback_params)
    if feedback.save
      # Trigger AI model update or answer ranking algorithm update
      # This is a placeholder for the actual implementation
      # Example: AiModelUpdateJob.perform_later(feedback.id)
      
      render json: { message: 'Feedback submitted successfully' }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end
end
