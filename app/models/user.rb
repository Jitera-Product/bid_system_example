class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable, :timeoutable
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  # Existing relationships from new code
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  # The new code had 'has_many :payment_methods' and 'has_many :wallets', but the existing code has 'has_one'.
  # We need to decide which one to keep based on the actual database schema.
  # If the schema has changed to support many payment methods and wallets, we should use 'has_many'.
  # Otherwise, we should keep 'has_one'.
  has_many :payment_methods, dependent: :destroy
  has_many :wallets, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :chat_channels, dependent: :destroy
  has_many :messages, dependent: :destroy

  # Validations from new code
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true

  # Existing validations
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Existing methods
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

  # Add any new methods from new code below if needed
  # For example, a method to check if a user is confirmed:
  # def confirmed?
  #   confirmed_at.present?
  # end
end
