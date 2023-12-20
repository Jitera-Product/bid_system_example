class Api::AdminsPasswordsController < Api::BaseController
  def create
    if current_resource_owner.valid_password?(params.dig(:old_password))
      if current_resource_owner.update(password: params.dig(:new_password))
        head :ok, message: I18n.t('common.200')
      else
        render json: { messages: current_resource_owner.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      render json: { message: I18n.t('email_login.passwords.old_password_mismatch') }, status: :unprocessable_entity
    end
  end

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

  private

  def update_password_params
    params.permit(:id, :password, :password_confirmation)
  end
end
