class Moder < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Password validation constants
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/

  # Password validations
  validates :password, presence: { message: I18n.t('activerecord.errors.messages.blank') },
                       length: { minimum: 8, message: I18n.t('activerecord.errors.messages.password_too_short') },
                       format: { with: PASSWORD_FORMAT, message: I18n.t('activerecord.errors.messages.password_invalid') },
                       confirmation: { message: I18n.t('activerecord.errors.messages.password_confirmation_mismatch') },
                       if: -> { new_record? || password.present? }

  # Password confirmation validation
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }

  # Callback to generate confirmation token before creating a new record
  before_create :generate_confirmation_token

  private

  # Method to generate a unique confirmation token
  def generate_confirmation_token
    self.confirmation_token = Devise.token_generator.generate(self.class, :confirmation_token).first
  end
end
