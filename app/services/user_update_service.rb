
class UserUpdateService
  VALID_ROLES = %w[Administrator Moderator User].freeze

  def update_user_role(user_id, new_role)
    user = User.find(user_id)
    raise 'Invalid role' unless VALID_ROLES.include?(new_role)

    if Api::UsersPolicy.new(user, nil).update_role?
      user.update!(role: new_role)
      Rails.logger.info "User role updated: user_id=#{user_id}, new_role=#{new_role}"
    else
      raise 'Unauthorized to update user role'
    end
  end

  # ... existing code ...
end
