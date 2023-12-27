module Api
  class FeedbacksController < BaseController
    before_action :doorkeeper_authorize!
    before_action :authenticate_inquirer, only: [:create]
    before_action :validate_comment_length, only: [:create] # Added new before_action for comment validation

    def create
      answer = Answer.find_by(id: feedback_params[:answer_id])
      user = User.find_by(id: feedback_params[:user_id])

      if answer.nil?
        render json: { error: 'Answer not found.' }, status: :bad_request and return
      elsif user.nil?
        render json: { error: 'User not found.' }, status: :bad_request and return
      elsif !feedback_params[:score].to_i.between?(1, 5)
        render json: { error: 'Score must be between 1 and 5.' }, status: :bad_request and return
      end

      feedback_service = FeedbackCreationService.new
      feedback = feedback_service.create_feedback(
        feedback_params[:answer_id],
        feedback_params[:user_id],
        feedback_params[:score],
        feedback_params[:comment]
      )

      if feedback.persisted?
        render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
      else
        render json: error_response(feedback, feedback.errors), status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def feedback_params
      params.require(:feedback).permit(:answer_id, :user_id, :score, :comment)
    end

    def authenticate_inquirer
      # Assuming there is a current_user method available from doorkeeper
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user&.role == 'Inquirer'
    end

    def validate_comment_length
      if feedback_params[:comment].length > 500
        render json: { error: 'You cannot input more than 500 characters.' }, status: :bad_request and return
      end
    end

    def error_response(resource, errors)
      { error: "Error saving #{resource.class.name.downcase}", details: errors.full_messages }
    end
  end
end
