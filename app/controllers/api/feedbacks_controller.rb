class Api::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_inquirer, only: [:create]
  before_action :validate_answer, only: [:create]
  before_action :check_existing_feedback, only: [:create]

  def create
    feedback = Feedback.new(feedback_params)
    if feedback.usefulness.is_a?(TrueClass) || feedback.usefulness.is_a?(FalseClass)
      if feedback.save
        update_answer_relevance(feedback)
        render json: { status: 201, feedback: feedback.as_json.merge({ created_at: feedback.created_at.iso8601 }) }, status: :created
      else
        render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Usefulness must be true or false.' }, status: :bad_request
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end

  def validate_inquirer
    unless current_user.role == 'inquirer' && User.exists?(id: params[:feedback][:inquirer_id])
      render json: { error: 'Invalid inquirer ID or inquirer not found.' }, status: :unauthorized and return
    end
  end

  def validate_answer
    unless Answer.exists?(id: params[:feedback][:answer_id])
      render json: { error: 'Answer not found.' }, status: :bad_request and return
    end
  end

  def check_existing_feedback
    existing_feedback = Feedback.find_by(answer_id: params[:feedback][:answer_id], inquirer_id: params[:feedback][:inquirer_id])
    if existing_feedback
      render json: { error: 'Feedback already exists for this answer by the inquirer' }, status: :conflict and return
    end
  end

  def update_answer_relevance(feedback)
    answer = Answer.find(feedback.answer_id)
    # Assuming there is a method in the Answer model to update relevance score
    answer.update_relevance_score(feedback.usefulness)
  end
end
