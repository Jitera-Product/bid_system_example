class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]

  def create
    # Ensure the answer exists
    answer = Answer.find_by(id: feedback_params[:answer_id])
    unless answer
      return render json: { error: 'Invalid answer ID.' }, status: :bad_request
    end

    # Ensure the inquirer exists and has the correct role
    inquirer = User.find_by(id: feedback_params[:inquirer_id])
    unless inquirer&.role == 'Inquirer'
      return render json: { error: 'Invalid inquirer ID or insufficient permissions.' }, status: :forbidden
    end

    # Validate usefulness is a boolean
    unless [true, false].include?(feedback_params[:usefulness])
      return render json: { error: 'Usefulness must be true or false.' }, status: :bad_request
    end

    # Validate comment length
    if feedback_params[:comment].present? && feedback_params[:comment].length > 500
      return render json: { error: 'The comment cannot exceed 500 characters.' }, status: :bad_request
    end

    # Create the feedback using the FeedbackService::Create
    feedback_service = FeedbackService::Create.new(
      answer_id: feedback_params[:answer_id],
      inquirer_id: feedback_params[:inquirer_id],
      usefulness: feedback_params[:usefulness],
      comment: feedback_params[:comment]
    )

    begin
      feedback = feedback_service.execute
      render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue Exceptions::InquirerNotFoundError => e
      render json: { error: e.message }, status: :forbidden
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end
end
