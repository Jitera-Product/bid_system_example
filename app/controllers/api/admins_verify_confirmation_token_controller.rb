class Api::AdminsVerifyConfirmationTokenController < Api::BaseController
  def create
    client = Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_secret])
    raise Exceptions::AuthenticationError if client.blank?

    resource = Admin.find_by(confirmation_token: params.dig(:confirmation_token))
    if resource.blank? || params.dig(:confirmation_token).blank?
      render error_message: I18n.t('email_login.reset_password.invalid_token'),
             status: :unprocessable_entity and return
    end

    if (resource.confirmation_sent_at + Admin.confirm_within) < Time.now.utc
      resource.resend_confirmation_instructions
      render json: { error_message: I18n.t('email_login.reset_password.expired') }, status: :unprocessable_entity
    else
      resource.confirm
      custom_token_initialize_values(resource, client)
    end
  end

  # New action to verify confirmation token
  def verify_confirmation_token
    confirmation_token = params[:confirmation_token]
    admin = Admin.find_by(confirmation_token: confirmation_token)

    if admin.present? && admin.confirmation_token_valid?
      Admin.transaction do
        admin.update!(confirmed_at: Time.current, confirmation_token: nil)
      end
      render json: { message: I18n.t('devise.confirmations.confirmed') }, status: :ok
    else
      render json: { error_message: I18n.t('errors.messages.invalid_token') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error_message: e.message }, status: :unprocessable_entity
  end

  private

  def custom_token_initialize_values(resource, client)
    # Existing method content
  end
end
