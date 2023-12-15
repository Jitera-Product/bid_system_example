class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable, :timeoutable
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  # Existing relationships from new code
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :payment_methods, dependent: :destroy # Changed from has_one to has_many to resolve conflict
  has_many :products, dependent: :destroy
  has_many :wallets, dependent: :destroy # Changed from has_one to has_many to resolve conflict
  has_many :questions, dependent: :destroy # Added from new code

  # Validations from new code
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true # Assuming this is needed for devise
  validates :username, presence: true, uniqueness: true # Added from new code
  validates :role, presence: true # Added from new code

  # Existing validations from existing code
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Custom methods from new code
  def update_login_info(ip_address)
    self.sign_in_count += 1
    self.last_sign_in_at = self.current_sign_in_at
    self.last_sign_in_ip = self.current_sign_in_ip
    self.current_sign_in_at = Time.current
    self.current_sign_in_ip = ip_address
    save
  end

  # Custom methods from existing code
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

  # Add any additional custom methods below this line
end
