class Api::ModersEmailAuthController < ApplicationController
  before_action :ensure_params_exist, only: [:confirm_email]

  def confirm_email
    token = params[:token]
    moder = Moder.find_by_confirmation_token(token)

    if moder.nil? || moder.confirmed_at.present?
      render json: { error: 'Confirmation token is not valid' }, status: :bad_request
    elsif moder.confirmation_sent_at.nil? || (moder.confirmation_sent_at + Devise.confirm_within) < Time.now.utc
      render json: { error: 'Confirmation token is expired' }, status: :bad_request
    else
      moder.confirmed_at = Time.now.utc
      if moder.save
        render json: { user: moder }, status: :ok
      else
        render json: { errors: moder.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
