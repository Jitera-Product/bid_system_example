class Api::AdminsResetPasswordRequestsController < Api::BaseController
  def create
    @admin = Admin.find_by('email = ?', params.dig(:email))
    @admin.send_reset_password_instructions if @admin.present?
    head :ok, message: I18n.t('common.200')
  end
end
