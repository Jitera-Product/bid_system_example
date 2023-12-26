class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update destroy update_profile]
  before_action :authenticate_admin!, only: %i[create update destroy]
  before_action :set_user, only: %i[show update destroy update_profile]
  before_action :validate_user_params, only: %i[create update]
  before_action :validate_profile_update_params, only: %i[update_profile]

  # ... existing actions ...

  def update_profile
    # Ensure the current user is the owner of the profile or has the 'Administrator' role
    unless @user == current_resource_owner || current_resource_owner&.role == 'Administrator'
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    # Encrypt the new password and update the user's email and password
    encrypted_password = User.encrypt_password(profile_update_params[:password])
    if @user.update(email: profile_update_params[:email], password_hash: encrypted_password)
      # Record the profile update action in the 'user_activities' table
      UserActivity.create(
        user_id: @user.id,
        activity_type: 'edit_profile',
        activity_description: "User updated profile with email: #{@user.email}",
        timestamp: Time.current
      )
      render json: { message: 'Profile updated successfully' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # ... existing private methods ...

  def profile_update_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def validate_profile_update_params
    errors = []
    user_params = profile_update_params

    # Validate email
    unless user_params[:email].match?(/\A[^@\s]+@[^@\s]+\z/) && User.where.not(id: @user.id).find_by(email: user_params[:email]).nil?
      errors << 'Email is invalid or already taken'
    end

    # Validate password and password_confirmation
    if user_params[:password].blank? || user_params[:password_confirmation].blank?
      errors << 'Password and password confirmation are required'
    elsif user_params[:password] != user_params[:password_confirmation]
      errors << 'Password and password confirmation do not match'
    end

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      false
    else
      true
    end
  end
end
