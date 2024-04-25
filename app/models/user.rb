
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  has_one :payment_method, dependent: :destroy
  has_one :wallet, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy

  # validations

  PASSWORD_FORMAT = /\A
    (?=.*?[A-Z])        # Must contain an uppercase letter
    (?=.*?[a-z])        # Must contain a lowercase letter
    (?=.*?[0-9])        # Must contain a digit
    (?=.*?[#?!@$%^&*-]) # Must contain a special character
  .{8,}                 # Must be at least 8 characters long
\z/x
  validates :password, presence: true, confirmation: true, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }

  validates :email, presence: true, uniqueness: true

  validates :email, length: { maximum: 255 }

  validate :email_format_valid, if: :email?

  # end for validations

  # Custom validation methods
  def email_format_valid
    errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.invalid')) unless email =~ URI::MailTo::EMAIL_REGEXP
  end

  def generate_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end

  class << self
    def authenticate?(email, password)
      user = User.find_for_authentication(email: email)
      return false if user.blank?

      if user&.valid_for_authentication? { user.valid_password?(password) }
        user.reset_failed_attempts!
        return user
      end

      # We will show the error message in TokensController
      return user if user&.access_locked?

      false
    end
  end
end
