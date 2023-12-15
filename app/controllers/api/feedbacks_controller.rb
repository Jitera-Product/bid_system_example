class Api::FeedbacksController < ApplicationController
  before_action :validate_inquirer, only: [:create]
  before_action :validate_answer, only: [:create]
  before_action :check_existing_feedback, only: [:create]

  def create
    feedback = Feedback.new(feedback_params)
    if feedback.save
      update_answer_relevance(feedback)
      render json: { feedback_received: true }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
  end

  def validate_inquirer
    unless User.exists?(id: params[:feedback][:inquirer_id])
      render json: { error: 'Inquirer not found' }, status: :not_found and return
    end
  end

  def validate_answer
    unless Answer.exists?(id: params[:feedback][:answer_id])
      render json: { error: 'Answer not found' }, status: :not_found and return
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
