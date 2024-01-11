class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable

  # Relationships
  has_one :payment_method, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :questions, dependent: :destroy # Added from new code

  # Validations
  validates :username, presence: true # Added from new code
  validates :password_hash, presence: true # Added from new code
  validates :role, presence: true # Added from new code
  validates :email, presence: true, uniqueness: true, length: { in: 0..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true # Added from new code

  # Password complexity requirement
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }

  # Additional fields for Devise
  # Confirmable
  validates :confirmation_token, presence: true, if: :confirmation_token_changed?
  validates :confirmed_at, presence: true, if: :confirmed_at_changed?
  validates :confirmation_sent_at, presence: true, if: :confirmation_sent_at_changed?
  validates :unconfirmed_email, presence: true, if: :unconfirmed_email_changed?

  # Lockable
  validates :failed_attempts, presence: true, numericality: { only_integer: true }
  validates :unlock_token, presence: true, if: :unlock_token_changed?
  validates :locked_at, presence: true, if: :locked_at_changed?

  # Trackable
  validates :sign_in_count, presence: true, numericality: { only_integer: true }
  validates :current_sign_in_at, presence: true, if: :current_sign_in_at_changed?
  validates :last_sign_in_at, presence: true, if: :last_sign_in_at_changed?
  validates :current_sign_in_ip, presence: true, if: :current_sign_in_ip_changed?
  validates :last_sign_in_ip, presence: true, if: :last_sign_in_ip_changed?

  # Recoverable
  validates :reset_password_token, presence: true, uniqueness: true, if: :reset_password_token_changed?
  validates :reset_password_sent_at, presence: true, if: :reset_password_sent_at_changed?

  # Rememberable
  validates :remember_created_at, presence: true, if: :remember_created_at_changed?

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
