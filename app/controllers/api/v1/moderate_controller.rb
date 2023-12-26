# FILE PATH: /app/controllers/api/v1/moderate_controller.rb

module Api
  module V1
    class ModerateController < Api::BaseController
      before_action :doorkeeper_authorize!
      before_action :authenticate_user!
      before_action :validate_admin_role, only: [:moderate_content, :update_question]
      before_action :set_content, only: [:update_question] # Ensuring set_content is called before update_question

      # ... existing methods ...

      # Method to handle question updates
      def update_question
        validate_question_params # Ensuring parameters are validated

        if @content.update(question_params)
          render json: { status: 200, question: @content.as_json.merge(updated_at: @content.updated_at) }, status: :ok
        else
          render json: { errors: @content.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # ... existing private methods ...

      def set_content
        @content = Question.find_by(id: params[:question_id]) # Using :question_id to find the content
        render json: { message: "Question not found." }, status: :not_found unless @content
      end

      def question_params
        params.require(:question).permit(:title, :content) # Using strong parameters for question
      end

      def validate_question_params
        render json: { message: "Question not found." }, status: :not_found unless @content
        if params[:question][:title].length > 200
          render json: { message: "You cannot input more than 200 characters for the title." }, status: :unprocessable_entity and return
        end

        if params[:question][:content].length > 10000
          render json: { message: "You cannot input more than 10000 characters for the content." }, status: :unprocessable_entity and return
        end
      end
    end
  end
end
