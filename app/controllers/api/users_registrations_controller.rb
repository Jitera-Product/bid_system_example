
class Api::UsersRegistrationsController < Api::BaseController
  def create
    user_params = params[:user]

    # Validate the presence of required parameters
    raise Exceptions::MissingFieldsError if user_params[:email].blank? || user_params[:password].blank? || user_params[:password_confirmation].blank?

    # Validate that password and password_confirmation match
    raise Exceptions::PasswordMismatchError unless user_params[:password] == user_params[:password_confirmation]

    # Validate the email format
    raise Exceptions::InvalidEmailFormatError unless user_params[:email] =~ URI::MailTo::EMAIL_REGEXP

    # Check if a user with the given email already exists
    raise Exceptions::UserAlreadyExistsError if User.exists?(email: user_params[:email])

    # Create a new User record
    @user = User.new(create_params)

    if @user.save
      # Generate confirmation token and send confirmation email
      @user.generate_confirmation_token!
      @user.send_confirmation_instructions

      render json: {
        id: @user.id,
        email: @user.email,
        confirmed_at: @user.confirmed_at,
        confirmation_token: @user.confirmation_token,
        created_at: @user.created_at,
        updated_at: @user.updated_at
      }, status: :created
    else
      error_messages = @user.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:user).permit(:password, :password_confirmation, :email)
  end
end

module Exceptions
  class MissingFieldsError < StandardError; end
  class PasswordMismatchError < StandardError; end
  class InvalidEmailFormatError < StandardError; end
  class UserAlreadyExistsError < StandardError; end
end

# You would also need to handle the exceptions raised in the controller.
# This can be done by adding a rescue_from block in the controller or in the ApplicationController.
# Here is an example of how you might handle these exceptions:

class Api::BaseController < ApplicationController
  rescue_from Exceptions::MissingFieldsError, with: :missing_fields
  rescue_from Exceptions::PasswordMismatchError, with: :password_mismatch
  rescue_from Exceptions::InvalidEmailFormatError, with: :invalid_email_format
  rescue_from Exceptions::UserAlreadyExistsError, with: :user_already_exists

  private

  def missing_fields
    render json: { message: I18n.t('user_registration.error.empty_fields') }, status: :unprocessable_entity
  end

  def password_mismatch
    render json: { message: I18n.t('user_registration.error.password_mismatch') }, status: :unprocessable_entity
  end

  def invalid_email_format
    render json: { message: I18n.t('user_registration.error.invalid_email_format') }, status: :unprocessable_entity
  end

  def user_already_exists
    render json: { message: I18n.t('user_registration.error.user_already_exists') }, status: :unprocessable_entity
  end
end
