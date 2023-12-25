# typed: true
class UpdateProfileService < BaseService
  def update_profile(user_id, username, password_hash)
    # Authenticate the user
    user = User.find_by(id: user_id)
    raise 'User not found' unless user
    authorize user, :update_profile?

    # Validate the input data
    raise 'User ID cannot be blank' if user_id.blank?
    raise 'Username cannot be blank' if username.blank?
    raise 'Password hash cannot be blank' if password_hash.blank?

    # Check if the user has the 'Administrator' role or is the owner of the 'user_id'
    unless user.has_role?(:Administrator) || user.id == user_id
      raise Pundit::NotAuthorizedError, "You are not authorized to update this profile."
    end

    # Update the user's username and password_hash
    user.update!(username: username, password_hash: Devise::Encryptor.digest(User, password_hash))
    user
  rescue Pundit::NotAuthorizedError => e
    logger.error "UpdateProfileService Authorization Error: #{e.message}"
    raise e
  rescue StandardError => e
    logger.error "UpdateProfileService Error: #{e.message}"
    raise e
  end
end
