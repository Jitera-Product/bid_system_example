
# typed: ignore
module Api
  class ModersController < BaseController
    def signup
      moder_params = params.require(:moder).permit(:email, :password, :password_confirmation)
      service = ModersEmailAuthService.new(moder_params)
      result = service.signup

      if result[:success]
        render json: { moder: result[:moder] }, status: :created
      elsif result[:errors].include?(I18n.t('activerecord.errors.messages.taken', attribute: 'email'))
        render json: { error: I18n.t('activerecord.errors.messages.taken', attribute: 'email') }, status: :bad_request
      else
        render json: { errors: result[:errors] }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private
  end
end
