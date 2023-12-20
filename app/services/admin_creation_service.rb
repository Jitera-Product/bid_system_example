# /app/services/admin_creation_service.rb
class AdminCreationService < BaseService
  include ActiveModel::Validations

  attr_accessor :email, :password, :password_confirmation, :name

  validates :email, :password, :name, presence: true
  validate :password_match

  def initialize(email, password, password_confirmation, name)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
    @name = name
  end

  def call
    return unless valid?

    existing_admin = Admin.find_by(email: email)
    if existing_admin
      return { error: 'Admin with this email already exists.' }
    end

    encrypted_password = Devise::Encryptor.digest(Admin, password)
    admin = Admin.create!(
      email: email,
      encrypted_password: encrypted_password,
      name: name
    )

    # Return the admin details excluding the encrypted password
    admin.attributes.except('encrypted_password')
  rescue ActiveRecord::RecordInvalid => e
    { error: e.record.errors.full_messages.to_sentence }
  end

  private

  def password_match
    errors.add(:password, "doesn't match password confirmation") if password != password_confirmation
  end
end
