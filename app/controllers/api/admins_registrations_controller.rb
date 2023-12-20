class Api::AdminsRegistrationsController < Api::BaseController
  def create
    # Validate input parameters
    unless valid_email?(create_params[:email])
      render json: { error: "Invalid email format." }, status: :bad_request and return
    end

    unless valid_password?(create_params[:password])
      render json: { error: "Password must be at least 8 characters long." }, status: :bad_request and return
    end

    unless create_params[:password] == create_params[:password_confirmation]
      render json: { error: "Password confirmation does not match." }, status: :unprocessable_entity and return
    end

    unless create_params[:name].present?
      render json: { error: "The name is required." }, status: :bad_request and return
    end

    # Check if an admin with the given email already exists
    existing_admin = Admin.find_by(email: create_params[:email])
    if existing_admin
      render json: { message: I18n.t('email_login.registrations.email_already_taken') }, status: :unprocessable_entity and return
    end

    @admin = Admin.new(create_params)
    if @admin.save
      # Generate a confirmation token and send a confirmation email
      @admin.generate_confirmation_token! if @admin.respond_to?(:generate_confirmation_token!)
      AdminMailer.confirmation_instructions(@admin, @admin.confirmation_token).deliver_later if @admin.confirmation_token.present?

      # Render a JSON response indicating that the registration is successful but pending email confirmation
      render json: { status: 201, admin: @admin.as_json(only: [:id, :email, :name, :created_at, :updated_at]) }, status: :created and return
    else
      error_messages = @admin.errors.full_messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def create_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :name)
  end

  def valid_email?(email)
    URI::MailTo::EMAIL_REGEXP.match?(email)
  end

  def valid_password?(password)
    password.length >= 8
  end
end
