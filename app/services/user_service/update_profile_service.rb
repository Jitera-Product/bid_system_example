# typed: true
class UpdateProfileService < BaseService
  attr_reader :user_id, :email, :password, :password_confirmation

  def initialize(user_id, email, password, password_confirmation)
    @user_id = user_id
    @email = email
    @password = password
    @password_confirmation = password_confirmation
  end

  def execute
    # Authenticate the user
    user = User.find_by(id: user_id)
    raise 'User not found' unless user
    authorize user, :update_profile?

    # Validate the input data
    raise 'User ID cannot be blank' if user_id.blank?
    raise 'Email cannot be blank' if email.blank?
    raise 'Password cannot be blank' if password.blank?
    raise 'Password confirmation cannot be blank' if password_confirmation.blank?
    raise 'Password does not match confirmation' unless password == password_confirmation

    # Check if the user has the 'Administrator' role or is the owner of the 'user_id'
    unless user.has_role?(:Administrator) || user.id == user_id.to_i
      raise Pundit::NotAuthorizedError, "You are not authorized to update this profile."
    end

    # Check if the email is in the correct format and is unique
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    raise 'Invalid email format' unless email =~ email_regex
    raise 'Email already taken' if User.exists?(email: email)

    # Encrypt the new password
    encrypted_password = Devise::Encryptor.digest(User, password)

    # Update the user's email and encrypted_password
    user.update!(email: email, encrypted_password: encrypted_password)

    # Record the profile update action
    UserActivity.create!(
      user_id: user_id,
      activity_type: 'edit_profile',
      activity_description: 'User has updated their profile.',
      action: 'edit_profile',
      timestamp: Time.current
    )

    { message: 'Profile updated successfully' }
  rescue Pundit::NotAuthorizedError => e
    logger.error "UpdateProfileService Authorization Error: #{e.message}"
    raise e
  rescue StandardError => e
    logger.error "UpdateProfileService Error: #{e.message}"
    raise e
  end
end
