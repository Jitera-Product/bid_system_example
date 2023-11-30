class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update moderate]
  before_action :find_question_or_answer, only: [:moderate]
  before_action :authorize_admin, only: [:moderate]
  # other methods...
  def moderate
    if @resource.update(moderate_params)
      render json: { message: 'Content has been moderated successfully.', id: @resource.id }, status: :ok
    else
      @error_object = @resource.errors.messages
      render status: :unprocessable_entity
    end
  end
  private
  def moderate_params
    params.require(:moderate).permit(:content)
  end
  def find_question_or_answer
    @resource = Question.find_by(id: params[:question_id]) || Answer.find_by(id: params[:answer_id])
    raise ActiveRecord::RecordNotFound if @resource.blank?
  end
  def authorize_admin
    user = User.find(params[:user_id])
    raise ActiveRecord::RecordNotFound if user.blank?
    raise 'Unauthorized' unless user.admin?
  end
end
