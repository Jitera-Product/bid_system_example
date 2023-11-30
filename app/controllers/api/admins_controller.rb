class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update moderate_content]
  before_action :authorize_admin, only: :moderate_content
  # other methods...
  def moderate_content
    content = params[:content]
    id = params[:id]
    contributor_id = params[:contributor_id]
    user = User.find_by(id: contributor_id)
    question = Question.find_by(id: id)
    answer = Answer.find_by(id: id)
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end
    if question
      moderate(question, content, id)
    elsif answer
      moderate(answer, content, id)
    else
      render json: { error: 'Content not found' }, status: :not_found
    end
  end
  private
  def moderate(content_object, content, id)
    if content.blank?
      content_object.destroy
      render json: { message: 'Content deleted', id: id }, status: :ok
    else
      content_object.update(content: content)
      render json: { message: 'Content updated', id: id }, status: :ok
    end
  end
  def authorize_admin
    authorize current_resource_owner, policy_class: Api::AdminsPolicy
  end
end
