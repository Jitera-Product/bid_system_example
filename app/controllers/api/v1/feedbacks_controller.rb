# typed: ignore
module Api
  module V1
    class FeedbacksController < BaseController
      include OauthTokensConcern

      before_action :authenticate_user!, only: [:create, :provide_feedback]
      before_action :verify_inquirer_role!, only: [:provide_feedback]

      # POST /api/v1/feedbacks
      def create
        # Check if the 'answer_id' corresponds to a valid `Answer` record
        answer = Answer.find_by(id: feedback_params[:answer_id])
        return render json: { error: 'Answer not found.' }, status: :bad_request unless answer

        # Check if the 'user_id' corresponds to a valid `User` record
        user = User.find_by(id: feedback_params[:user_id])
        return render json: { error: 'User not found.' }, status: :bad_request unless user

        # Validate the 'score' parameter
        unless feedback_params[:score].between?(1, 5)
          return render json: { error: 'Score must be between 1 and 5.' }, status: :bad_request
        end

        # Validate the 'comment' parameter
        if feedback_params[:comment].length > 500
          return render json: { error: 'You cannot input more than 500 characters.' }, status: :bad_request
        end

        # Create a new `Feedback` record with the provided parameters
        feedback = Feedback.new(feedback_params)

        if feedback.save
          render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
        else
          render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
        end
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end

      # POST /api/v1/feedbacks/provide_feedback
      def provide_feedback
        # Validate input parameters
        validate_feedback_params

        # Check if the 'answer_id' corresponds to a valid `Answer` record
        answer = Answer.find_by(id: feedback_params[:answer_id])
        return render json: { error: 'Answer not found.' }, status: :not_found unless answer

        # Check if the 'user_id' corresponds to a valid `User` record
        user = User.find_by(id: feedback_params[:user_id])
        return render json: { error: 'User not found.' }, status: :not_found unless user

        # Create a new `Feedback` record with the validated parameters
        feedback = Feedback.new(feedback_params)

        if feedback.save
          # Update the `feedback_score` of the associated `Answer` record
          AnswerUpdatingService.new(answer).update_feedback_score(feedback.score)

          # Return a confirmation response with the details of the submitted feedback
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

      def authenticate_user!
        authenticate_resource_owner!
      end

      def verify_inquirer_role!
        # Ensure the user has the role of "Inquirer"
        unless current_resource_owner.role == 'Inquirer'
          render json: { error: 'You must be an Inquirer to provide feedback.' }, status: :forbidden
        end
      end

      def validate_feedback_params
        feedback_params
        raise ArgumentError, 'Score must be between 1 and 5' unless feedback_params[:score].between?(1, 5)
        raise ArgumentError, 'Answer ID and User ID must be present' if feedback_params[:answer_id].blank? || feedback_params[:user_id].blank?
      end

      def feedback_params
        params.require(:feedback).permit(:answer_id, :user_id, :score, :comment).tap do |whitelisted|
          whitelisted[:score] = whitelisted[:score].to_i
        end
      end
    end
  end
end
