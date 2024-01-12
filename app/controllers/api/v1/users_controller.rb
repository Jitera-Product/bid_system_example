
class Api::V1::UsersController < ApplicationController
  before_action :doorkeeper_authorize!

  def update_role
    user_id = params[:user_id]
    new_role = params[:new_role]

    begin
      UserUpdateService.new.update_user_role(user_id, new_role)
      render json: { message: 'User role updated successfully.' }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :forbidden
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
