# FILE PATH: /app/controllers/api/v1/moderate_controller.rb

module Api
  module V1
    class ModerateController < Api::BaseController
      before_action :doorkeeper_authorize!
      before_action :authenticate_user!
      before_action :validate_admin_role, only: [:moderate_content]
      before_action :set_content, only: [:update, :delete_content] # Re-added set_content for update and delete_content actions

      def update
        case params[:action]
        when 'update'
          update_content
        when 'delete'
          delete_content
        else
          render json: { message: "Invalid action." }, status: :bad_request
        end
      end

      def moderate_content
        case moderate_params[:content_type]
        when 'question'
          content = Question.find_by(id: moderate_params[:content_id])
        when 'answer'
          content = Answer.find_by(id: moderate_params[:content_id])
        else
          render json: { message: "Invalid content type." }, status: :bad_request and return
        end

        if content.nil?
          render json: { message: "Content not found." }, status: :not_found and return
        end

        case moderate_params[:action]
        when 'approve'
          content.update(status: 'approved')
        when 'reject'
          content.destroy # Assuming rejection means deletion
        when 'edit'
          if moderate_params[:edited_content].present?
            content.update(text: moderate_params[:edited_content])
          else
            render json: { message: "Edited content can't be blank." }, status: :unprocessable_entity and return
          end
        else
          render json: { message: "Invalid action." }, status: :bad_request and return
        end

        render json: { content_id: content.id, action: moderate_params[:action] }, status: :ok
      end

      private

      def authenticate_user!
        # Assuming authenticate_user! is defined in Api::BaseController
      end

      def validate_admin_role
        # Assuming current_user and admin? methods are defined
        render json: { message: "Forbidden" }, status: :forbidden unless current_user&.admin?
      end

      def set_content
        @content = Question.find_by(id: params[:id]) || Answer.find_by(id: params[:id])
        render json: { message: "Content not found." }, status: :not_found unless @content
      end

      def moderate_params
        params.require(:moderation).permit(:content_id, :content_type, :action, :edited_content)
      end

      def update_content
        if @content.update(update_params)
          render json: { status: 200, message: "Content has been updated successfully." }, status: :ok
        else
          render json: { errors: @content.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def delete_content
        if @content.destroy
          render json: { status: 200, message: "Content has been successfully deleted." }, status: :ok
        else
          render json: { errors: @content.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update_params
        params.require(:content).permit(:title, :content)
      end
    end
  end
end
