class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_user!, only: [:update_role]

  # ... other actions ...

  def update_role
    target_user_id = params[:id]
    new_role = params[:role]
    admin_id = current_resource_owner.id

    # Check if the current user is an administrator
    unless current_resource_owner.admin?
      return render json: { message: 'Forbidden' }, status: :forbidden
    end

    user = User.find_by(id: target_user_id)
    if user.nil?
      render json: { message: 'User not found' }, status: :not_found
    elsif !User.roles.include?(new_role)
      render json: { message: 'Invalid role value.' }, status: :unprocessable_entity
    else
      user.role = new_role
      if user.save
        render json: { status: 200, user: { id: user.id, role: user.role, updated_at: user.updated_at } }, status: :ok
      else
        render json: { message: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  # ... other actions ...
end
