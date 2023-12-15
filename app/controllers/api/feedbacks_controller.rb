class Api::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_inquirer, only: [:create]
  before_action :validate_answer, only: [:create]
  before_action :validate_rating, only: [:create], if: -> { feedback_params[:rating].present? }
  before_action :check_existing_feedback, only: [:create]
  before_action :validate_user, only: [:create] # Added new before_action for user validation
  before_action :validate_comment_length, only: [:create] # Added new before_action for comment length validation

  def create
    feedback = Feedback.new(feedback_params.except(:inquirer_id)) # Removed :inquirer_id from feedback_params as it's not needed for the new requirements
    if feedback_params[:rating].present?
      handle_rating_feedback(feedback)
    else
      handle_usefulness_feedback(feedback)
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:answer_id, :user_id, :rating, :usefulness, :comment) # Removed :inquirer_id from permitted params
  end

  def validate_inquirer
    inquirer_id = params[:feedback][:user_id]
    unless current_user.role == 'Inquirer' && User.exists?(id: inquirer_id)
      render json: { error: 'Invalid inquirer ID or inquirer not found.' }, status: :unauthorized and return
    end
  end

  def validate_answer
    unless Answer.exists?(id: params[:feedback][:answer_id])
      render json: { error: 'Answer not found' }, status: :not_found and return
    end
  end

  def validate_rating
    rating = params[:feedback][:rating].to_i
    unless rating.is_a?(Integer) && rating.between?(1, 5)
      render json: { error: 'Rating must be a number between 1 and 5.' }, status: :unprocessable_entity and return
    end
  end

  def validate_user
    unless User.exists?(id: params[:feedback][:user_id])
      render json: { error: 'User not found.' }, status: :bad_request and return
    end
  end

  def validate_comment_length
    if params[:feedback][:comment].length > 500
      render json: { error: 'Comment cannot exceed 500 characters.' }, status: :unprocessable_entity and return
    end
  end

  def check_existing_feedback
    existing_feedback = Feedback.find_by(answer_id: params[:feedback][:answer_id], user_id: params[:feedback][:user_id])
    if existing_feedback
      render json: { error: 'Feedback already exists for this answer by the user' }, status: :conflict and return
    end
  end

  def handle_rating_feedback(feedback)
    if feedback.save
      update_answer_rating(feedback)
      render json: { status: 201, feedback: feedback.as_json.merge({ created_at: feedback.created_at.iso8601 }) }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def handle_usefulness_feedback(feedback)
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

  def update_answer_rating(feedback)
    answer = Answer.find(feedback.answer_id)
    answer.recalculate_rating(feedback.rating)
  end

  def update_answer_relevance(feedback)
    answer = Answer.find(feedback.answer_id)
    answer.update_relevance_score(feedback.usefulness)
  end
end
