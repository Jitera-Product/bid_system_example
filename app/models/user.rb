class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  # Associations
  has_one :payment_method, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :wallets, dependent: :destroy
  has_many :questions, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: true, length: { in: 3..20 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates :role, presence: true, inclusion: { in: %w(admin user) }
  validates :encrypted_password, presence: true
  validates :sign_in_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :failed_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }

  validates :email, length: { in: 0..255 }, if: :email?

  # Callbacks
  before_save :encrypt_password, if: :password_required?

  # Custom methods
  def password_required?
    password.present? || password_confirmation.present?
  end

  def encrypt_password
    if password.present?
      self.encrypted_password = BCrypt::Password.create(password)
    end
  end

  def update_last_login_time
    self.last_sign_in_at = Time.current
    save(validate: false)
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

  # More custom methods and logic as needed
end
