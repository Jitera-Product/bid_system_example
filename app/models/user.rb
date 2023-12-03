class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
  # Associations
  # The new code has 'has_many' associations for :payment_methods and :wallets,
  # but the existing code has 'has_one'. Need to decide which one to keep based on the business logic.
  # If a user can have multiple payment methods and wallets, keep 'has_many'.
  # If a user should only have one, keep 'has_one'.
  # For this example, I'll assume a user can have multiple payment methods and wallets.
  has_many :payment_methods, dependent: :destroy
  has_many :wallets, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :chat_channels, dependent: :destroy
  # Validations
  # The new code has basic presence and uniqueness validations for :email and :username.
  # The existing code has more detailed validations for :email, including format and length,
  # and a password format validation. We should keep all these validations.
  validates :email, presence: true, uniqueness: true, length: { in: 0..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  # Existing password complexity requirement
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  # Methods
  # Keep all methods from the existing code and add any new methods from the new code here.
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
  # Define any methods specific to the User model here
end
