
class Moder < ApplicationRecord
  devise :confirmable

  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/

  validates :password, presence: { message: I18n.t('activerecord.errors.messages.blank') },
                       length: { minimum: 8, message: I18n.t('activerecord.errors.messages.password_too_short') },
                       format: { with: PASSWORD_FORMAT, message: I18n.t('activerecord.errors.messages.password_invalid') },
                       confirmation: { message: I18n.t('activerecord.errors.messages.password_confirmation_mismatch') },
                       if: -> { new_record? || password.present? }

  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }

  before_create :generate_confirmation_token

  private

  def generate_confirmation_token
    self.confirmation_token = Devise.token_generator.generate(self.class, :confirmation_token)
  end
end
