class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  # Associations
  # The new code has 'has_many :payment_methods' and 'has_many :wallets' which conflicts with the existing 'has_one :payment_method' and 'has_one :wallet'.
  # To resolve this, we need to decide whether a user should have many or one of each. Assuming a user can have multiple payment methods and wallets, we will use 'has_many'.
  has_many :payment_methods, dependent: :destroy
  has_many :wallets, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :messages, dependent: :destroy

  # Validations
  # The new code does not include password format validation, which is important for security. We will keep the existing password format validation.
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :email, presence: true, uniqueness: true, length: { in: 0..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true
  validates :name, presence: true

  # Methods
  # The existing code has a method for generating a reset password token and an authentication method. These should be kept.
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

  # Define any methods that are specific to the User model here
end
