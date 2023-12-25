module Api
  class FeedbacksController < BaseController
    before_action :doorkeeper_authorize!
    before_action :authenticate_inquirer, only: [:create]

    def create
      answer = Answer.find_by(id: feedback_params[:answer_id])
      inquirer = User.find_by(id: feedback_params[:inquirer_id], role: 'Inquirer')

      if answer.nil?
        render json: { error: 'Answer not found.' }, status: :bad_request and return
      elsif inquirer.nil?
        render json: { error: 'Inquirer not found.' }, status: :forbidden and return
      elsif !feedback_params[:score].to_i.between?(1, 5)
        render json: { error: 'Score must be between 1 and 5.' }, status: :bad_request and return
      elsif feedback_params[:comment].length > 1000
        render json: { error: 'You cannot input more than 1000 characters.' }, status: :bad_request and return
      end

      feedback = Feedback.new(feedback_params)

      if feedback.save
        render json: { status: 201, feedback: feedback.as_json.merge(created_at: feedback.created_at.iso8601) }, status: :created
      else
        render json: error_response(feedback, feedback.errors), status: :unprocessable_entity
      end
    end

    private

    def feedback_params
      params.require(:feedback).permit(:answer_id, :inquirer_id, :score, :comment)
    end

    def authenticate_inquirer
      # Assuming there is a current_user method available from doorkeeper
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user&.role == 'Inquirer'
    end

    def error_response(resource, errors)
      { error: "Error saving #{resource.class.name.downcase}", details: errors.full_messages }
    end
  end
end
