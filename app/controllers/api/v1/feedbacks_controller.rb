# typed: ignore
module Api
  module V1
    class FeedbacksController < BaseController
      include OauthTokensConcern

      # POST /api/v1/feedbacks/provide_feedback
      def provide_feedback
        authenticate_inquirer!

        answer_id = feedback_params[:answer_id]
        inquirer_id = current_resource_owner.id
        return render json: { error: 'Answer does not exist.' }, status: :not_found unless Answer.exists?(answer_id)

        feedback = Feedback.new(
          answer_id: answer_id,
          inquirer_id: inquirer_id,
          usefulness: feedback_params[:usefulness],
          comment: feedback_params[:comment],
          created_at: feedback_params[:created_at] || Time.current
        )

        if feedback.save
          # Adjust AI's future answer selection here if necessary
          # This is a placeholder for the logic that would be implemented
          # by the AI system based on the feedback received.
          # Example: AIAdjustmentService.new(feedback).adjust_answers

          render json: { success: true, message: 'Feedback successfully created.', feedback_id: feedback.id }, status: :created
        else
          render json: { success: false, errors: feedback.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def authenticate_inquirer!
        authenticate_resource_owner!
      end

      def feedback_params
        params.require(:feedback).permit(:answer_id, :usefulness, :comment, :created_at)
      end
    end
  end
end
