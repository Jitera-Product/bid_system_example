# typed: true
# frozen_string_literal: true

class ModerMailer < ApplicationMailer
  def email_confirmation(moder)
    @moder = moder
    mail(to: @moder.email, subject: I18n.t('email_login.registrations.confirm_account'))
  end
end


