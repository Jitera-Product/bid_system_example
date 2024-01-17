class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  # Associations
  has_one :payment_method, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :questions, dependent: :destroy, foreign_key: :user_id
  has_many :bid_items, dependent: :destroy, foreign_key: :user_id
  has_many :bids, dependent: :destroy, foreign_key: :user_id
  has_many :deposits, dependent: :destroy, foreign_key: :user_id
  has_many :products, dependent: :destroy, foreign_key: :user_id

  # Validations
  enum role: { member: 0, admin: 1, super_admin: 2, contributor: 3 } # Added contributor role from new code and kept existing roles

  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :email, presence: true, uniqueness: true, length: { in: 0..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true, if: :encrypted_password? # Added conditional check for encrypted_password presence
  validates :username, presence: true, uniqueness: true, if: :username? # Added conditional check for username presence and uniqueness

  # Methods
  def generate_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end

  # Check if the user has a contributor role
  def contributor?
    role == 'contributor'
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
