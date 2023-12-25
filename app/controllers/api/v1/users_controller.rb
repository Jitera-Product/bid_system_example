# app/controllers/api/v1/users_controller.rb

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:update_profile, :edit_profile] # Added :edit_profile action
  before_action :authorize_user!, only: [:update_profile, :edit_profile] # Added :edit_profile action
  before_action :validate_edit_profile_params, only: [:edit_profile] # New before_action for edit_profile

  # Add other actions here if they exist

  def update_profile
    # Validate the input
    unless params[:user_id] && !params[:username].blank? && !params[:password_hash].blank?
      error_messages = []
      error_messages << 'User ID is required.' unless params[:user_id]
      error_messages << 'Username is required and cannot be empty.' if params[:username].blank?
      error_messages << 'Password hash is required.' if params[:password_hash].blank?
      return render json: { error: error_messages.join(' ') }, status: :bad_request
    end

    # Use the `set_user` private method to find the user by 'user_id'
    set_user
    return unless @user

    begin
      # Perform the update operation on the user's 'username' and 'password_hash'
      if @user.update(username: params[:username], password_hash: params[:password_hash])
        render json: { status: 200, user: user_response(@user) }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # New action for editing user profile
  def edit_profile
    # Assuming there is a method to hash the password
    hashed_password = hash_password(params[:password])

    if @user.update(username: params[:username], password_hash: hashed_password)
      render json: { status: 200, user: user_response(@user) }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  def authorize_user!
    unless current_user == @user || current_user.role == 'Administrator'
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def validate_edit_profile_params
    error_messages = []
    error_messages << 'You cannot input more than 50 characters.' if params[:username].length > 50
    error_messages << 'Password must be at least 8 characters long.' if params[:password].length < 8
    render json: { error: error_messages.join(' ') }, status: :bad_request unless error_messages.empty?
  end

  def hash_password(password)
    # Method to hash the password, this should be implemented or referenced from a service if it exists
    # For the purpose of this example, we'll simulate a hashing mechanism
    Digest::SHA256.hexdigest(password)
  end

  def user_response(user)
    {
      id: user.id,
      username: user.username,
      updated_at: user.updated_at.iso8601
    }
  end
end
