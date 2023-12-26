# app/controllers/api/v1/users_controller.rb

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:update_profile, :edit_profile] # Added :edit_profile action
  before_action :authorize_user!, only: [:update_profile, :edit_profile] # Added :edit_profile action
  before_action :validate_edit_profile_params, only: [:edit_profile] # New before_action for edit_profile

  # Add other actions here if they exist

  def update_profile
    # Existing update_profile action code
  end

  # New action for editing user profile
  def edit_profile
    begin
      # Encrypt the new password
      encrypted_password = Devise::Encryptor.digest(User, params[:password])

      # Update the user's email and password_hash
      if @user.update(email: params[:email], password_hash: encrypted_password)
        # Log the activity
        UserActivity.create!(
          user_id: @user.id,
          activity_type: 'profile_update',
          activity_description: 'User updated profile',
          action: 'edit_profile',
          timestamp: Time.current
        )

        # Return a confirmation response
        render json: { message: 'Profile updated successfully.' }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
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
    required_params = %w[email password password_confirmation]
    missing_params = required_params.select { |param| params[param].blank? }
    unless missing_params.empty?
      render json: { error: "Missing parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    unless params[:password] == params[:password_confirmation]
      render json: { error: 'Password confirmation does not match password.' }, status: :bad_request
      return
    end

    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    unless params[:email].match(email_regex)
      render json: { error: 'Invalid email format.' }, status: :bad_request
      return
    end

    if User.exists?(email: params[:email])
      render json: { error: 'Email is already taken.' }, status: :bad_request
      return
    end
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
