# frozen_string_literal: true

class Api::UsersSessionsController < ApplicationController
  before_action :validate_login_params

  def create
    user = find_user_by_username
    if user && user.valid_password?(params[:password_hash])
      token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id)
      render json: { token: token.token, role: user.role }, status: :created
    else
      logger.info "Failed login attempt for user #{params[:username]}"
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def validate_login_params
    render json: { error: 'Username and password are required' }, status: :bad_request unless params[:username].present? && params[:password_hash].present?
  end

  def find_user_by_username
    User.find_by(username: params[:username])
  end
end
