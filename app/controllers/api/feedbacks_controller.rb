# frozen_string_literal: true

module Api
  class FeedbacksController < BaseController
    before_action :authenticate_user!

    def create
      authorize Feedback
      feedback = Feedback.new(feedback_params)

      if feedback.save
        render json: { status: 201, feedback: feedback.as_json }, status: :created
      else
        render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def feedback_params
      params.require(:feedback).permit(:comment, :usefulness, :answer_id).merge(user_id: current_user.id)
    end
  end
end

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

      if result[:status] == :created
        render json: { status: 201, feedback: result[:feedback] }, status: :created
      else
        render json: { errors: result[:errors] }, status: result[:status]
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def feedback_params
      params.permit(:answer_id, :comment, :usefulness)
    end
  end
end
