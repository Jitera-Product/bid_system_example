# typed: ignore
module Api
  class FeedbacksController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_feedback_creation, only: [:create]
    before_action :validate_feedback_params, only: [:create]

    def create
      answer = Answer.find_by(id: params[:answer_id])
      return render json: { error: 'Invalid answer ID.' }, status: :bad_request unless answer

      inquirer = User.find_by(id: params[:inquirer_id], role: 'inquirer')
      return render json: { error: 'Invalid inquirer ID.' }, status: :unauthorized unless inquirer

      feedback = answer.feedbacks.new(feedback_params)
      if feedback.save
        FeedbackService::Index.new(feedback).update_ai_model
        render json: { status: 201, feedback: feedback.as_json }, status: :created
      else
        render json: error_response(feedback, StandardError.new('Feedback could not be saved')), status: :unprocessable_entity
      end
    end

    private

    def feedback_params
      params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
    end

    def authorize_feedback_creation
      authorize Feedback
    end

    def validate_feedback_params
      render json: { error: 'Invalid usefulness value.' }, status: :bad_request unless Feedback.usefulnesses.keys.include?(params[:feedback][:usefulness])
      render json: { error: 'You cannot input more than 1000 characters.' }, status: :bad_request if params[:feedback][:comment].to_s.length > 1000
    end
  end
end
