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

  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }

  validates :email, presence: true, uniqueness: true

  validates :email, length: { in: 0..255 }, if: :email?

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # end for validations

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
