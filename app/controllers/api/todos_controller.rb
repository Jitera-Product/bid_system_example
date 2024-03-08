
class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    todo = current_resource_owner.todos.new(todo_params)

    authorize todo, policy_class: Api::UsersPolicy

    if todo.save
      render json: { status: 201, todo: todo.as_json }, status: :created
    else
      render json: { errors: todo.errors }, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :priority, :recurring, :category_id, attachments: [])
  end
end
