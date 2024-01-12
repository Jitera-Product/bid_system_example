class Api::V1::FeedbacksController < BaseController
  before_action :authenticate_user!
  before_action :authorize_feedback_creation, only: [:create]
  before_action :validate_feedback_params, only: [:create]

  def authorize_feedback_creation
    authorize Feedback, :create?
  end

  def validate_feedback_params
    unless Answer.exists?(params[:answer_id])
      render json: { errors: 'Invalid answer ID.' }, status: :bad_request and return
    end

    unless User.exists?(id: params[:inquirer_id], role: 'Inquirer')
      render json: { errors: 'Invalid inquirer ID.' }, status: :bad_request and return
    end

    unless [true, false].include?(params[:usefulness])
      render json: { errors: 'Usefulness must be true or false.' }, status: :bad_request and return
    end
  end

  def create
    answer = Answer.find(params[:answer_id])
    feedback = Feedback.new(
      answer_id: answer.id,
      inquirer_id: current_user.id,
      usefulness: params[:usefulness],
      comment: params[:comment]
    )

    if feedback.save
      FeedbackService.new.update_relevance_score(answer, params[:usefulness])
      render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
