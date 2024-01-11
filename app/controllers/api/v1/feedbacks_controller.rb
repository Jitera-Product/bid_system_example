# /app/controllers/api/v1/feedbacks_controller.rb
class Api::V1::FeedbacksController < Api::BaseController
  before_action :authenticate_user!

  def create
    # Validate the parameters
    unless feedback_params[:content].present?
      return render json: { error: 'The content is required.' }, status: :bad_request
    end

    unless valid_usefulness?(feedback_params[:usefulness])
      return render json: { error: 'Invalid value for usefulness.' }, status: :bad_request
    end

    unless feedback_params[:question_id].is_a?(Integer)
      return render json: { error: 'Wrong format.' }, status: :bad_request
    end

    # Instantiate the FeedbackService::Create service class
    feedback_service = FeedbackService::Create.new(feedback_params)
    result = feedback_service.execute

    # Handle the result of the service execution
    if result[:errors].blank?
      render json: { status: 201, feedback: result[:feedback] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { errors: [e.message] }, status: :internal_server_error
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content, :usefulness, :question_id)
  end

  def valid_usefulness?(value)
    ['helpful', 'not_helpful', 'neutral'].include?(value)
  end
end
