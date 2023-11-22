class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :trackable, :recoverable, :lockable, :confirmable

  has_many :aproved_products,
           class_name: 'Product',
           foreign_key: :aproved_id, dependent: :destroy
  has_many :aprroved_withdrawals,
           class_name: 'Withdrawal',
           foreign_key: :aprroved_id, dependent: :destroy
  has_many :created_categories,
           class_name: 'Category',
           foreign_key: :created_id, dependent: :destroy

  # validations

  PASSWORD_FORMAT = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
  validates :password, format: PASSWORD_FORMAT, if: -> { new_record? || password.present? }

  validates :name, presence: true

  validates :name, length: { in: 0..255 }, if: :name?

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
      admin = Admin.find_for_authentication(email: email)
      return false if admin.blank?

      if admin&.valid_for_authentication? { admin.valid_password?(password) }
        admin.reset_failed_attempts!
        return admin
      end

      # We will show the error message in TokensController
      return admin if admin&.access_locked?

      false
    end
  end
end
