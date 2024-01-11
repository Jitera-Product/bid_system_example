# frozen_string_literal: true

class Api::UsersSessionsController < ApplicationController
  before_action :validate_login_params, except: [:authenticate]
  before_action :validate_auth_params, only: [:authenticate]
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
    user = AuthenticationService.authenticate(params[:username], params[:password])
    if user
      token = AuthenticationService.generate_token(user)
      render json: { status: 200, token: token }, status: :ok
    else
      render json: { error: 'The username or password is incorrect.' }, status: :unauthorized
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def validate_login_params
    render json: { error: 'Username and password are required' }, status: :bad_request unless params[:username].present? && params[:password_hash].present?
  end

  def validate_auth_params
    errors = []
    errors << "The username is required." if params[:username].blank?
    errors << "The password is required." if params[:password].blank?
    render json: { errors: errors }, status: :bad_request if errors.any?
  end

  def log_login_attempt(username, password)
    user = find_user_by_username(username)
    if user && user.valid_password?(password)
      logger.info "Successful login attempt for user #{username}"
    else
      logger.info "Failed login attempt for user #{username}"
    end
  end

  def find_user_by_username(username = nil)
    username ||= params[:username]
    User.find_by(username: username)
  end

  def handle_authentication_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
