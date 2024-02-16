# frozen_string_literal: true

class ModersEmailAuthService
  attr_reader :moder_params, :confirmation_token

  def initialize(moder_params)
    @moder_params = moder_params
    @confirmation_token = @moder_params[:confirmation_token]
  end

  def signup
    email = @moder_params[:email]
    password = @moder_params[:password]

    return { error: 'Email is already taken' } if Moder.exists?(email: email)

    confirmation_token = Devise.friendly_token
    moder = Moder.new(email: email, password: password, confirmation_token: confirmation_token)

    if moder.save
      ModerMailer.email_confirmation(moder).deliver_later
      { user: moder }
    else
      { error: moder.errors.full_messages.join(', ') }
    end
  rescue ActiveRecord::RecordNotUnique => e
    { error: I18n.t('activerecord.errors.messages.taken', attribute: 'email') }
  rescue StandardError => e
    { error: e.message }
  end

  def confirm_email
    moder = Moder.find_by(confirmation_token: confirmation_token)

    if moder.nil?
      return { error: I18n.t('controller.moder.confirmation_token_invalid') }
    elsif moder.confirmation_sent_at.nil? || (moder.confirmation_sent_at + Devise.confirm_within) < Time.now.utc
      return { error: I18n.t('controller.moder.confirmation_token_expired') }
    else
      moder.confirmed_at = Time.now.utc
      if moder.save
        ModerMailer.confirmation_email(moder).deliver_later
        return { user: moder }
      else
        return { error: moder.errors.full_messages.join(', ') }
      end
    end
  rescue StandardError => e
    { error: e.message }
  end
end
