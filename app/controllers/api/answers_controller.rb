
class Api::AnswersController < Api::BaseController
  include AuthenticationConcern
  
  def update
    authenticate_user!
    answer = Answer.find(params[:answer_id])
    authorize answer, :update?

    if AnswerService::Update.new(answer, params[:content]).call
      render json: { message: 'Answer has been updated successfully.' }, status: :ok
    else
      render json: { message: 'Unable to update the answer.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Answer not found.' }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { message: 'You are not authorized to update this answer.' }, status: :forbidden
  rescue StandardError => e
    render json: error_response(nil, e), status: :internal_server_error
  end

  # Other controller actions...
end
