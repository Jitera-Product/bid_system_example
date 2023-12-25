# FILE PATH: /app/controllers/api/v1/moderate_controller.rb

module Api
  module V1
    class ModerateController < Api::BaseController
      before_action :doorkeeper_authorize!
      before_action :authenticate_user!
      before_action :validate_admin_role, only: [:moderate_content, :update_question] # Added :update_question to the list
      before_action :set_content, only: [:update, :delete_content] # Removed :update_question from the list

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
        # ... existing moderate_content method ...
      end

      # New method to handle question updates
      def update_question
        # Validation moved to a private method for better organization
        validate_question_params

        if @content.update(title: params[:title], content: params[:content])
          render json: { status: 200, question: @content.as_json.merge(updated_at: @content.updated_at) }, status: :ok
        else
          render json: { errors: @content.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def authenticate_user!
        # ... existing authenticate_user! method ...
      end

      def validate_admin_role
        # ... existing validate_admin_role method ...
      end

      def set_content
        @content = Question.find_by(id: params[:id])
        render json: { message: "Content not found." }, status: :not_found unless @content
      end

      def moderate_params
        # ... existing moderate_params method ...
      end

      def update_content
        # ... existing update_content method ...
      end

      def delete_content
        # ... existing delete_content method ...
      end

      def update_params
        # ... existing update_params method ...
      end

      # New private method for question parameter validation
      def validate_question_params
        if params[:title].length > 200
          render json: { message: "You cannot input more than 200 characters for the title." }, status: :unprocessable_entity and return
        end

        if params[:content].length > 10000
          render json: { message: "You cannot input more than 10000 characters for the content." }, status: :unprocessable_entity and return
        end
      end
    end
  end
end
