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
        return render json: { error: 'Invalid answer ID.' }, status: :bad_request unless Answer.exists?(answer_id)
        return render json: { error: 'Invalid inquirer ID or insufficient permissions.' }, status: :forbidden unless User.exists?(id: inquirer_id, role: 'Inquirer')
        return render json: { error: 'Usefulness must be true or false.' }, status: :unprocessable_entity unless [true, false].include?(feedback_params[:usefulness])

        feedback = Feedback.new(
          answer_id: answer_id,
          inquirer_id: inquirer_id,
          usefulness: feedback_params[:usefulness],
          comment: feedback_params[:comment],
          created_at: Time.current
        )

        if feedback.save
          render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
        else
          render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def authenticate_inquirer!
        authenticate_resource_owner!
        # Ensure the user has the role of "Inquirer"
        unless current_resource_owner.role == 'Inquirer'
          render json: { error: 'You must be an Inquirer to provide feedback.' }, status: :forbidden
        end
      end

      def feedback_params
        params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
      end
    end
  end
end
