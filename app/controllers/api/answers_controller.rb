class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update]
  def update
    @answer = Answer.find_by(id: params[:id], user_id: params[:user_id])
    if @answer.nil?
      render json: { error: 'Answer not found or user not authorized' }, status: :not_found
    else
      if @answer.update(content: params[:content])
        render json: { message: 'Answer updated successfully', id: @answer.id }, status: :ok
      else
        render json: { error: 'Failed to update answer' }, status: :unprocessable_entity
      end
    end
  end
end
