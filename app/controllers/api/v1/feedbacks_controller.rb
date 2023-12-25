# typed: ignore
module Api
  module V1
    class FeedbacksController < BaseController
      include OauthTokensConcern

      before_action :authenticate_inquirer!, only: [:create_feedback]

      # POST /api/v1/feedbacks/provide_feedback
      def provide_feedback
        authenticate_inquirer!

        answer = Answer.find_by(id: feedback_params[:answer_id])
        return render json: { error: 'Invalid answer ID.' }, status: :not_found unless answer
        return render json: { error: 'Score must be within the allowed range.' }, status: :unprocessable_entity unless feedback_params[:score].to_i.between?(1, 5)

        feedback = Feedback.new(
          answer_id: answer.id,
          inquirer_id: current_resource_owner.id,
          score: feedback_params[:score],
          comment: feedback_params[:comment]
        )

        if feedback.save
          AnswerUpdatingService.new(answer).update_feedback_score
          render json: { message: 'Feedback created successfully.', feedback: feedback }, status: :created
        else
          render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
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
        params.require(:feedback).permit(:answer_id, :score, :comment)
      end
    end
  end
end
