class Api::AdminsVerifyResetPasswordRequestsController < Api::BaseController
  def create
    reset_password_token = params[:reset_password_token]
    token = Devise.token_generator.digest(Admin, :reset_password_token, reset_password_token)

    @admin = Admin.find_by(reset_password_token: token)

    if @admin.blank? || reset_password_token.blank?
      render json: { error: I18n.t('reset_password.invalid_token') }, status: :not_found
    elsif !@admin.reset_password_period_valid?
      render json: { error: I18n.t('errors.messages.expired') }, status: :unprocessable_entity
    else
      render json: { message: I18n.t('reset_password.valid_token') }, status: :ok
    end
  end

  # PUT /api/admins_verify_reset_password_requests
  def update
    reset_password_token = params[:reset_password_token]
    new_password = params[:new_password]
    new_password_confirmation = params[:new_password_confirmation]

    # Validate input parameters
    return render json: { error: 'Reset password token is required.' }, status: :bad_request if reset_password_token.blank?
    return render json: { error: 'New password must be at least 8 characters long.' }, status: :unprocessable_entity if new_password.length < 8
    return render json: { error: 'New password confirmation does not match.' }, status: :unprocessable_entity if new_password != new_password_confirmation

    # Find the admin by the digested token
    token = Devise.token_generator.digest(Admin, :reset_password_token, reset_password_token)
    admin = Admin.find_by(reset_password_token: token)

    # Check if admin exists and if the token is valid
    if admin.present? && admin.reset_password_period_valid?
      # Attempt to reset the password
      if admin.reset_password(new_password, new_password_confirmation)
        # Clear the reset_password_token
        admin.update_attribute(:reset_password_token, nil)
        render json: { message: 'Your password has been reset successfully.' }, status: :ok
      else
        render json: { error: 'Failed to reset password.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid token or admin not found.' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Admin not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
