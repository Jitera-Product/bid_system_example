# typed: ignore
module Api
  module V1
    class FeedbacksController < BaseController
      include OauthTokensConcern

      before_action :authenticate_inquirer!, only: [:create_feedback, :provide_feedback]

      # POST /api/v1/feedbacks/provide_feedback
      def provide_feedback
        authenticate_inquirer!

        answer = Answer.find_by(id: feedback_params[:answer_id])
        inquirer = User.find_by(id: feedback_params[:inquirer_id])

        return render json: { error: 'Answer not found.' }, status: :not_found unless answer
        return render json: { error: 'Inquirer not found.' }, status: :not_found unless inquirer
        return render json: { error: 'Score must be between 1 and 5.' }, status: :unprocessable_entity unless feedback_params[:score].to_i.between?(1, 5)
        return render json: { error: 'You cannot input more than 1000 characters.' }, status: :unprocessable_entity if feedback_params[:comment].length > 1000

        feedback = Feedback.new(
          answer_id: answer.id,
          inquirer_id: inquirer.id,
          score: feedback_params[:score],
          comment: feedback_params[:comment]
        )

        if feedback.save
          AnswerUpdatingService.new(answer).update_feedback_score
          render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
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
        params.require(:feedback).permit(:answer_id, :inquirer_id, :score, :comment)
      end
    end
  end
end
