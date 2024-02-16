
class Api::ModersEmailAuthController < ApplicationController
  rescue_from Exceptions::ModerConfirmationError, with: :handle_moder_confirmation_error

  before_action :ensure_params_exist, only: [:confirm_email]

  def confirm_email
    token = params[:confirmation_token]
    moder = Moder.find_by_confirmation_token(token)

    if moder.nil?
      raise Exceptions::ModerConfirmationError.new(I18n.t('controller.moder.confirmation_token_invalid'))
    elsif moder.confirmation_sent_at.nil? || (moder.confirmation_sent_at + Devise.confirm_within) < Time.now.utc
      raise Exceptions::ModerConfirmationError.new(I18n.t('controller.moder.confirmation_token_expired'))
    else
      moder.confirm
      render json: { user: moder }, status: :ok
    end
  end

  private

  def handle_moder_confirmation_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
