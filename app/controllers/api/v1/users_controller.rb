class Api::V1::UsersController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :authorize_admin, only: [:update_user_role]

  def update_role
    # This method seems to be deprecated and should be removed or updated to match the new requirements.
    user_id = params[:user_id]
    new_role = params[:new_role]

    begin
      UserUpdateService.new.update_user_role(user_id, new_role)
      render json: { message: 'User role updated successfully.' }, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :forbidden
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def update_user_role
    user_id = params[:id]
    new_role = params[:role]

    # Validate user_id format
    unless user_id.to_s.match?(/\A\d+\z/)
      render json: { error: 'Wrong format.' }, status: :bad_request and return
    end

    # Validate role
    unless ['contributor', 'inquirer', 'administrator'].include?(new_role)
      render json: { error: 'Invalid role value.' }, status: :bad_request and return
    end

    begin
      user = User.find(user_id)
      authorize user, policy_class: Api::UsersPolicy

      updated_user = UserUpdateService.new.update_user_role(user_id, new_role)
      render json: { status: 200, user: { id: updated_user.id, username: updated_user.username, role: updated_user.role } }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found.' }, status: :not_found
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :forbidden
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def authorize_admin
    # Assuming there's a method to check if the current user is an admin
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
  end
end
