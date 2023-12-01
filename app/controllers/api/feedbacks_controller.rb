class Api::FeedbacksController < ApplicationController
  before_action :doorkeeper_authorize!
  def create
    feedback = Feedback.new(feedback_params)
    if feedback.valid? && User.exists?(params[:feedback][:user_id]) && Answer.exists?(params[:feedback][:answer_id])
      feedback.save
      render json: { message: 'Feedback successfully created', id: feedback.id }, status: :created
    else
      render json: { error: 'Invalid parameters' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def feedback_params
    params.require(:feedback).permit(:content, :user_id, :answer_id)
  end
end
