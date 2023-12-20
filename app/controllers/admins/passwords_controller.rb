class Admins::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  # PUT /resource/password
  def update
    # Strong parameters
    reset_password_params = params.require(:admin).permit(:reset_password_token, :password, :password_confirmation)

    # Find the admin by reset_password_token
    admin = Admin.find_by(reset_password_token: reset_password_params[:reset_password_token])

    # Check if admin exists and if password matches confirmation
    if admin && reset_password_params[:password] == reset_password_params[:password_confirmation]
      # Reset the password
      if admin.reset_password(reset_password_params[:password], reset_password_params[:password_confirmation])
        # Clear the reset_password_token
        admin.update_attribute(:reset_password_token, nil)
        render json: { message: 'Password has been reset successfully.' }, status: :ok
      else
        render json: { error: 'Failed to reset password.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid token or password confirmation does not match.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Admin not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  protected

  def after_resetting_password_path_for(resource)
    signed_in_root_path(resource)
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end
end
