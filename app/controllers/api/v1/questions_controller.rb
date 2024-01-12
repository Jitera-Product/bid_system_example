# typed: true
# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::BaseController
      before_action :doorkeeper_authorize!

      def create
        authorize :question, :create?
        service = QuestionSubmissionService.new(question_params, current_resource_owner.id)
        question_id = service.call
        render json: { question_id: question_id }, status: :created
      rescue Pundit::NotAuthorizedError
        render json: { error: 'User is not authorized to create questions.' }, status: :forbidden
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def question_params
        params.permit(:title, :content, :category, tags: [])
      end
    end
  end
end
