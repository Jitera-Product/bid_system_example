# typed: ignore
module Api
  class FeedbacksController < BaseController
    before_action :authenticate_user!
    before_action :validate_answer_id, only: [:create]
    before_action :validate_user_id, only: [:create]
    before_action :validate_usefulness, only: [:create]

    def create
      authorize Feedback
      feedback = Feedback.new(feedback_params)

      if feedback.save
        render json: { status: :created, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
      else
        render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: error_response(nil, e), status: :internal_server_error
    end

    private

    def feedback_params
      params.require(:feedback).permit(:answer_id, :user_id, :comment, :usefulness)
    end

    def validate_answer_id
      unless Answer.exists?(params[:feedback][:answer_id])
        render json: { error: "Answer not found." }, status: :bad_request and return
      end
    end

    def validate_user_id
      unless User.exists?(params[:feedback][:user_id])
        render json: { error: "User not found." }, status: :bad_request and return
      end
    end

    def validate_usefulness
      unless Feedback.usefulnesses.keys.include?(params[:feedback][:usefulness])
        render json: { error: "Invalid value for usefulness." }, status: :bad_request and return
      end
    end
  end
end
