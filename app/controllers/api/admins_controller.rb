class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update moderate_content]
  # other methods...
  def moderate_content
    id = params[:id]
    action = params[:action]
    content = Content.find_by(id: id)
    unless content
      render json: { error: 'Content does not exist' }, status: :not_found
      return
    end
    begin
      case action
      when 'approve'
        content.approve!
      when 'edit'
        content.edit!
      when 'delete'
        content.destroy!
      else
        render json: { error: 'Invalid action' }, status: :unprocessable_entity
        return
      end
      render json: { message: 'Action performed successfully' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
