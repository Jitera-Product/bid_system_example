
class Api::FeedbacksController < ApplicationController
  before_action :authenticate_inquirer!

  def create
    answer = Answer.find_by(id: feedback_params[:answer_id])
    return render json: { error: 'Invalid answer ID.' }, status: :bad_request unless answer

    # Validate that the usefulness is a boolean
    unless [true, false].include?(feedback_params[:usefulness])
      return render json: { error: 'Usefulness must be true or false.' }, status: :unprocessable_entity
    end

    # Create the feedback
    feedback = Feedback.new(feedback_params.merge(created_at: Time.current))
    if feedback.save
      # Update the associated answer's feedback score
      AnswerService::Index.new(answer).update_feedback_score(feedback)

      # Logic to adjust AI's future responses based on feedback
      AiAdjustmentService.new(feedback).perform if defined?(AiAdjustmentService)

      render json: { status: 201, feedback_id: feedback.id }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_inquirer!
    head :unauthorized unless current_user&.role == 'Inquirer'
  end

  def feedback_params
    params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end
end
