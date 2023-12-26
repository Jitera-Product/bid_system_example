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

      # Update the user's username and encrypted password
      if @user.update(username: params[:username], encrypted_password: encrypted_password)
        # Log the activity
        UserActivity.create!(
          user_id: @user.id,
          activity_type: 'profile_update',
          activity_description: 'User updated profile',
          action: 'edit_profile',
          timestamp: Time.current
        )

        # Return a confirmation response with the user's updated information
        render json: { status: 200, user: user_response(@user) }, status: :ok
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
    required_params = %w[username password]
    missing_params = required_params.select { |param| params[param].blank? }
    unless missing_params.empty?
      render json: { error: "Missing parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    if params[:username].length > 50
      render json: { error: 'You cannot input more than 50 characters.' }, status: :bad_request
      return
    end

    if params[:password].length < 8
      render json: { error: 'Password must be at least 8 characters long.' }, status: :bad_request
      return
    end
  end

  def user_response(user)
    {
      id: user.id,
      username: user.username,
      role: user.role,
      updated_at: user.updated_at.iso8601
    }
  end
end
