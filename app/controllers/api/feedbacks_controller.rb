module Api
  class FeedbacksController < BaseController
    before_action :doorkeeper_authorize!
    before_action :authenticate_inquirer, only: [:create]

    def create
      answer = Answer.find_by(id: feedback_params[:answer_id])
      inquirer = User.find_by(id: feedback_params[:inquirer_id], role: 'Inquirer')

      if answer.nil?
        render json: { error: 'Invalid answer ID.' }, status: :bad_request and return
      elsif inquirer.nil?
        render json: { error: 'Invalid inquirer ID or insufficient permissions.' }, status: :forbidden and return
      elsif !is_boolean?(feedback_params[:usefulness])
        render json: { error: 'Usefulness must be true or false.' }, status: :bad_request and return
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
      params.require(:feedback).permit(:answer_id, :inquirer_id, :usefulness, :comment)
    end

    def authenticate_inquirer
      # Assuming there is a current_user method available from doorkeeper
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user&.role == 'Inquirer'
    end

    def is_boolean?(value)
      [true, false].include? value
    end
  end
end
