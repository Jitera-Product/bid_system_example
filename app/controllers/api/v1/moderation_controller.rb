# typed: ignore
module Api
  module V1
    class ModerationController < BaseController
      before_action :authenticate_admin!

      def moderate
        authorize :admin, :moderate_content?

        moderation_service = ModerationService.new
        if moderation_service.moderate_content(params[:content_id], params[:content_type], params[:status], current_user.id, params[:reason])
          render json: { message: I18n.t('controller.moderation_success') }, status: :ok
        else
          render json: { message: I18n.t('controller.moderation_error') }, status: :forbidden
        end
      rescue UnauthorizedModerationError
        render json: { message: I18n.t('controller.moderation_error') }, status: :unauthorized
      end
    end
  end
end
