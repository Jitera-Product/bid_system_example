class Api::V1::FeedbacksController < Api::BaseController
  before_action :authenticate_user!
  before_action :set_answer, only: [:create]
  before_action :authorize_feedback_creation, only: [:create]

  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    content = feedback_params[:content]
    usefulness = feedback_params[:usefulness]
    answer_id = feedback_params[:answer_id]

    validate_usefulness(usefulness)

    feedback = FeedbackService.create_feedback(
      comment: content,
      usefulness: usefulness,
      answer_id: answer_id
    )

    render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at) }, status: :created
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_answer
    @answer = Answer.find(feedback_params[:answer_id])
  end

  def authorize_feedback_creation
    authorize(@answer, :create_feedback?)
  end

  def handle_record_invalid(e)
    render json: { error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  def handle_record_not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def validate_usefulness(usefulness)
    unless [true, false].include?(usefulness)
      render json: { error: 'Usefulness must be true or false.' }, status: :unprocessable_entity
    end
  end

  def feedback_params
    params.require(:feedback).permit(:content, :usefulness, :answer_id)
  end
end
