module Api
  class FeedbacksController < ApplicationController
    before_action :doorkeeper_authorize!

    def create
      authorize :feedback, policy_class: Api::FeedbackPolicy

      feedback_service = FeedbackService.new
      result = feedback_service.create_feedback(
        answer_id: feedback_params[:answer_id],
        user_id: current_resource_owner.id,
        comment: feedback_params[:comment],
        usefulness: feedback_params[:usefulness]
      )

      render json: { message: result }, status: :created
    end

    private

    def feedback_params
      params.permit(:answer_id, :comment, :usefulness)
    end
  end
end
