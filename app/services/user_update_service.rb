class UserUpdateService
  VALID_ROLES = %w[Administrator Moderator User Contributor Inquirer].freeze

  def update_user_role(user_id, new_role)
    raise 'Wrong format.' unless user_id.is_a?(Integer)
    user = User.find_by(id: user_id)
    raise 'User not found.' if user.nil?
    raise 'Invalid role value.' unless VALID_ROLES.include?(new_role.capitalize)

    if user.role == 'Administrator' && Api::UsersPolicy.new(user, nil).update_role?
      user.update!(role: new_role.capitalize)
      Rails.logger.info "User role updated: user_id=#{user_id}, new_role=#{new_role}"
      { status: 200, user: { id: user.id, username: user.username, role: user.role } }
    else
      raise 'Unauthorized to update user role'
    end
  rescue ActiveRecord::RecordInvalid => e
    raise 'Unprocessable Entity'
  rescue => e
    Rails.logger.error "Internal Server Error: #{e.message}"
    raise 'Internal Server Error'
  end

  # ... other methods in UserUpdateService ...
end
