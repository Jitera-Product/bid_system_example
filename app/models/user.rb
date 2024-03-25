
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  has_one :payment_method, dependent: :destroy
  has_one :wallet, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :bid_items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :wallets, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :bids, dependent: :destroy

  # validations

  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }

  validates :email, presence: true, uniqueness: true

  validates :email, length: { in: 0..255 }, if: :email?

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_presence_of :display_name, message: I18n.t('validation.en.blank')
  validates_presence_of :gender, message: I18n.t('validation.en.blank')
  validates_presence_of :date_of_birth, message: I18n.t('validation.en.blank')
  validates_presence_of :area, message: I18n.t('validation.en.area_and_menu_required')
  validates_presence_of :menu, message: I18n.t('validation.en.area_and_menu_required')

  validates_length_of :display_name, maximum: 20, message: I18n.t('validation.en.display_name_too_long')

  validates_inclusion_of :gender, in: User.genders.keys, message: I18n.t('validation.en.gender_invalid')
  validate :validate_date_of_birth_format

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

  private

  def validate_date_of_birth_format
    errors.add(:date_of_birth, I18n.t('validation.en.date_of_birth_invalid')) unless date_of_birth.is_a?(Date)
  end

  # Custom validation for images will be added here
  # validate :validate_images

end
