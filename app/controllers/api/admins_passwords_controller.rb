class Api::AdminsPasswordsController < Api::BaseController
  before_action :authorize_reset_password, only: [:create, :change_password]

  # POST /admins/passwords
  def create
    admin = Admin.find_by(email: admin_password_params[:email])
    if admin
      # Generate a reset_password_token and store it with the timestamp
      raw, enc = Devise.token_generator.generate(Admin, :reset_password_token)
      admin.reset_password_token = enc
      admin.reset_password_sent_at = Time.now.utc
      if admin.save
        # Send password reset email with raw token (not stored in DB)
        AdminMailer.reset_password_instructions(admin, raw).deliver_later
        render json: { message: I18n.t('admins_passwords.instructions_sent') }, status: :ok
      else
        render json: { message: I18n.t('admins_passwords.instructions_not_sent') }, status: :unprocessable_entity
      end
    elsif current_resource_owner.valid_password?(params.dig(:old_password))
      if current_resource_owner.update(password: params.dig(:new_password))
        head :ok, message: I18n.t('common.200')
      else
        render json: { messages: current_resource_owner.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      render json: { message: I18n.t('admins_passwords.admin_not_found') }, status: :not_found
    end
  rescue StandardError => e
    render json: { message: I18n.t('admins_passwords.error', error: e.message) }, status: :internal_server_error
  end

  # PATCH/PUT /admins/passwords/:id
  def update_password
    admin = Admin.find_by(id: update_password_params[:id])
    if admin.nil?
      render json: { message: I18n.t('admin.passwords.update.not_found') }, status: :not_found
      return
    end

    if update_password_params[:password] == update_password_params[:password_confirmation]
      if admin.update(password: update_password_params[:password])
        render json: { message: I18n.t('admin.passwords.update.success') }, status: :ok
      else
        render json: { messages: admin.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: I18n.t('admin.passwords.update.confirmation_mismatch') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: I18n.t('admin.passwords.update.not_found') }, status: :not_found
  end

  # POST /api/admins_passwords
  def change_password
    unless params[:id].is_a?(Integer)
      return render json: { message: "Wrong format." }, status: :unprocessable_entity
    end

    admin = Admin.find_by(id: params[:id])
    return render json: { message: "Admin not found." }, status: :not_found unless admin

    unless admin.valid_password?(params[:current_password])
      return render json: { message: "Current password is incorrect." }, status: :unauthorized
    end

    new_password = params[:new_password]
    if new_password.length < 8
      return render json: { message: "New password must be at least 8 characters long." }, status: :unprocessable_entity
    end

    unless new_password == params[:new_password_confirmation]
      return render json: { message: "New password confirmation does not match." }, status: :unprocessable_entity
    end

    if admin.update(password: new_password)
      render json: { message: "Password changed successfully." }, status: :ok
    else
      render json: { messages: admin.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Admin not found." }, status: :not_found
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end

  private

  def admin_password_params
    params.permit(:email, :old_password, :new_password)
  end

  def update_password_params
    params.permit(:id, :current_password, :new_password, :new_password_confirmation)
  end

  def authorize_reset_password
    # Assuming there is a policy set up for this controller
    authorize [:api, :admins_password], :reset_password?
  end
end
