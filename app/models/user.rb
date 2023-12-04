class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable, :timeoutable
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  # Existing relationships
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :wallets, dependent: :destroy

  # Existing validations
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :sign_in_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :failed_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_owner, inclusion: { in: [true, false] }

  # Password format validation
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  # Email validations
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Methods
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

      return user if user&.access_locked?

      false
    end
  end

  # Callbacks
  # Add any callbacks like before_save, after_commit, etc here if needed

  # Scopes
  # Define any custom scopes here if needed

  # Additional methods
  # Define any instance or class methods here if needed
end
