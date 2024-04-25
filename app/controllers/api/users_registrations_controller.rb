class Api::UsersRegistrationsController < Api::BaseController
  def create
    # Validate input fields
    unless params[:user][:email].present? && params[:user][:password].present? && params[:user][:password_confirmation].present?
      render json: { message: I18n.t('user_registration.error.empty_fields') }, status: :unprocessable_entity and return
    end

    # Check password confirmation
    unless params[:user][:password] == params[:user][:password_confirmation]
      render json: { message: I18n.t('user_registration.error.password_mismatch') }, status: :unprocessable_entity and return
    end

    @user = User.new(create_params)
    if @user.save
      # Generate confirmation token and send confirmation email
      @user.generate_confirmation_token!
      @user.send_confirmation_instructions

      if Rails.env.staging?
        # to show token in staging
        token = @user.respond_to?(:confirmation_token) ? @user.confirmation_token : ''
        render json: { message: I18n.t('common.200'), token: token }, status: :ok and return
      else
        render json: {
          user_id: @user.id,
          email: @user.email,
          confirmation_status: @user.confirmed?,
          created_at: @user.created_at,
          updated_at: @user.updated_at
        }, status: :ok and return
      end
    else
      error_messages = @user.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end

  def create_params
    params.require(:user).permit(:password, :password_confirmation, :email)
  end
end
