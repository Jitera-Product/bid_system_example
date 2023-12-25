# FILE PATH: /app/controllers/api/v1/moderate_controller.rb

module Api
  module V1
    class ModerateController < Api::BaseController
      before_action :doorkeeper_authorize!
      before_action :set_content, only: [:update]
      before_action :validate_type, only: [:update]
      before_action :validate_status, only: [:update]

      def update
        authorize :moderate, policy_class: Api::ModeratePolicy

        if @content.update(status: params[:status])
          render json: { status: 200, message: "Content has been successfully moderated." }, status: :ok
        else
          render json: { errors: @content.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_content
        @content = params[:type].classify.constantize.find(params[:id])
      rescue NameError
        render json: { message: "Invalid type specified." }, status: :bad_request
      rescue ActiveRecord::RecordNotFound
        render json: { message: "Content not found." }, status: :not_found
      end

      def validate_type
        unless %w[question answer].include?(params[:type])
          render json: { message: "Invalid type specified." }, status: :bad_request
        end
      end

      def validate_status
        unless %w[approved rejected pending].include?(params[:status])
          render json: { message: "Invalid status value." }, status: :bad_request
        end
      end
    end
  end
end
