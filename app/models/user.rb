class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :wallets, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :messages, dependent: :destroy
  # validations
  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :gender, inclusion: { in: %w(male female other) }
  validates :location, presence: true
  validates :interests, presence: true
  validates :preferences, presence: true
  validates :name, presence: true
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
    def create(name:, age:, gender:, location:, interests:, preferences:)
      user = User.new(
        name: name,
        age: age,
        gender: gender,
        location: location,
        interests: interests,
        preferences: preferences
      )
      if user.save
        return user.id
      else
        return false
      end
    end
  end
end
