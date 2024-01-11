
# frozen_string_literal: true

class Api::UsersSessionsController < ApplicationController
  before_action :validate_login_params, except: [:authenticate]
  rescue_from Exceptions::AuthenticationError, with: :handle_authentication_error

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

  # POST /api/users/authenticate
  def authenticate
    username = params[:username]
    password = params[:password]
    log_login_attempt(username, password)

    # Validation
    return render json: { error: "The username is required." }, status: :bad_request if username.blank?
    return render json: { error: "The password is required." }, status: :bad_request if password.blank?

    user = User.authenticate?(username, password)
    if user
      token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id)
      render json: {
        status: 200,
        access_token: token.token,
        role: user.role,
        id: user.id,
        username: user.username,
        role: user.role
      }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def validate_login_params
    render json: { error: 'Username and password are required' }, status: :bad_request unless params[:username].present? && params[:password_hash].present?
  end

  def log_login_attempt(username, password)
    user = find_user_by_username(username)
    if user && user.valid_password?(password)
      logger.info "Successful login attempt for user #{username}"
    else
      logger.info "Failed login attempt for user #{username}"
    end
  end

  def find_user_by_username(username)
    User.find_by(username: username)
  end

  def handle_authentication_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
