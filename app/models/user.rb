class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable, :timeoutable
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  # Relationships
  # The new code has 'has_many :payment_methods' and 'has_many :wallets' which conflicts with the existing 'has_one' relationships.
  # To resolve the conflict, we need to decide whether a user should have many or one of each.
  # Assuming a user should only have one of each, we keep the existing 'has_one' relationships.
  has_one :payment_method, dependent: :destroy
  has_one :wallet, dependent: :destroy

  # The rest of the relationships do not conflict, so we can keep them as they are.
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  # Validations
  # The new code adds a validation for :name, which does not conflict with existing validations.
  validates :name, presence: true

  # The existing code has more detailed email validations and a custom password format validation.
  # We will keep these and not override them with the less specific validations from the new code.
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :email, presence: true, uniqueness: true, length: { in: 0..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Methods
  # The existing code has methods that do not conflict with the new code, so we can keep them as they are.
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
