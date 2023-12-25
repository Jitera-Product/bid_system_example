# app/controllers/api/v1/users_controller.rb

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:update_profile]
  before_action :authorize_user!, only: [:update_profile]

  # Add other actions here if they exist

  def update_profile
    if user_params[:username].blank?
      return render json: { error: 'The username is required.' }, status: :bad_request
    end

    if user_params[:password_hash].blank?
      return render json: { error: 'The password is required.' }, status: :bad_request
    end

    if @user.update(user_params)
      render json: { status: 200, user: user_response(@user) }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  def authorize_user!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:username, :password_hash)
  end

  def user_response(user)
    {
      id: user.id,
      username: user.username,
      updated_at: user.updated_at.iso8601
    }
  end
end
