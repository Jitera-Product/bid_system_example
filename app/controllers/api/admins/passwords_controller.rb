# app/controllers/api/admins/passwords_controller.rb

class Api::Admins::PasswordsController < Api::BaseController
  # POST /api/admins/passwords
  def create
    admin = Admin.find_by(email: params[:email])

    if admin.present?
      # Generate a unique password reset token
      raw, enc = Devise.token_generator.generate(Admin, :reset_password_token)
      
      # Store the token and the timestamp in the admin's record
      admin.reset_password_token = enc
      admin.reset_password_sent_at = Time.now.utc
      
      # Save the changes to the admin record
      if admin.save
        # Send the password reset email
        AdminMailer.reset_password_instructions(admin, raw).deliver_now
        render json: { message: 'Password reset instructions have been sent to your email.' }, status: :ok
      else
        render json: { error: 'Unable to save reset password token.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Email not found.' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
