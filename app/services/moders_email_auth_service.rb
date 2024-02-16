# frozen_string_literal: true

class ModersEmailAuthService
  def initialize(moder_params)
    @moder_params = moder_params
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
  rescue StandardError => e
    { error: e.message }
  end
end
