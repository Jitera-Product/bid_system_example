# typed: ignore
module Api
  class FeedbacksController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_feedback_creation, only: [:create]

    def create
      answer = Answer.find(params[:answer_id])
      feedback = answer.feedbacks.new(feedback_params)

      if feedback.save
        FeedbackService::Index.new(feedback).update_learning_model
        render json: { message: 'Feedback has been recorded successfully.' }, status: :created
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
  end
end
