module Api
  module V1
    class ModerationController < BaseController
      before_action :doorkeeper_authorize!
      before_action :validate_moderation_params, only: [:update_status]

      VALID_STATUSES = ['approved', 'rejected'].freeze

      def update_status
        authorize :moderate, :update?
        record = find_record
        if VALID_STATUSES.include?(params[:status]) && record.update(status: params[:status])
          render json: { status: 200, message: 'The content has been successfully moderated.' }, status: :ok
        else
          render json: { message: 'Invalid status value.' }, status: :unprocessable_entity
        end
      rescue Pundit::NotAuthorizedError
        render json: { message: 'You are not authorized to perform this action' }, status: :forbidden
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'The specified content is not found.' }, status: :not_found
      end

      private

      def validate_moderation_params
        unless %w[question answer].include?(params[:type])
          render json: { message: "Type must be either 'question' or 'answer'." }, status: :bad_request
          return
        end

        unless params[:id].to_s.match?(/\A\d+\z/)
          render json: { message: 'Wrong format.' }, status: :bad_request
          return
        end

        validator = ModerationValidator.new(params.permit(:type, :id, :status))
        unless validator.valid?
          render json: { message: validator.errors.full_messages }, status: :unprocessable_entity
          return
        end
      end

      def find_record
        case params[:type]
        when 'question'
          Question.find(params[:id])
        when 'answer'
          Answer.find(params[:id])
        else
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
