class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :authenticate_inquirer, only: [:create]

  def create
    validate_feedback_params

    feedback_service = FeedbackService.new
    feedback = feedback_service.create_feedback(
      comment: feedback_params[:comment],
      usefulness: feedback_params[:usefulness],
      inquirer_id: current_resource_owner.id,
      answer_id: feedback_params[:answer_id]
    )

    if feedback.persisted?
      render json: { status: 201, feedback: feedback.as_json }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def authenticate_inquirer
    # Assuming there's a method to authenticate inquirer similar to user authentication
    # This method should set a current_resource_owner if inquirer is authenticated
  end

  def validate_feedback_params
    required_params = params.require(:feedback).permit(:comment, :usefulness, :answer_id)
    raise ArgumentError, "The comment is required." if required_params[:comment].blank?
    raise ArgumentError, "Usefulness must be true or false." unless [true, false].include?(required_params[:usefulness])
    raise ArgumentError, "Answer ID must be a number." unless required_params[:answer_id].is_a?(Numeric)
    required_params
  end

  def feedback_params
    params.require(:feedback).permit(:comment, :usefulness, :answer_id)
  end
end
