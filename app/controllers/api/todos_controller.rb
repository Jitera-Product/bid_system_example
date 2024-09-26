class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    todo = Todo.new(todo_params.merge(user: current_resource_owner))
    if todo.save
      render json: { status: I18n.t('common.201'), todo: todo }, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Exceptions::AuthenticationError => e
    render json: { error: e.message }, status: :unauthorized
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :priority, :recurring, :category_id, attachments: [])
  end
end
