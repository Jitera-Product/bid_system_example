class Api::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  before_action :validate_params, only: [:create]
  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      render json: { status: 200, feedback: @feedback }, status: :ok
    else
      render json: @feedback.errors, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def feedback_params
    params.require(:feedback).permit(:content, :answer_id, :user_id)
  end
  def authorize_user!
    unless current_user.role == 'inquirer'
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
  def validate_params
    render json: { error: 'The content is required.' }, status: :bad_request if params[:content].blank?
    render json: { error: 'Wrong format' }, status: :bad_request unless params[:answer_id].is_a?(Integer)
    render json: { error: 'Wrong format' }, status: :bad_request unless params[:user_id].is_a?(Integer)
    render json: { error: 'This answer is not found' }, status: :not_found unless Answer.exists?(params[:answer_id])
  end
end
