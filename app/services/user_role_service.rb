# typed: true
class UserRoleService < BaseService
  def update_role(target_user_id:, new_role:, admin_id:)
    admin = User.find_by(id: admin_id)
    raise 'Admin not found' unless admin

    policy = Api::UsersPolicy.new(admin, nil)
    raise 'Not authorized to update role' unless policy.update_role?

    target_user = User.find_by(id: target_user_id)
    raise 'Target user not found' unless target_user

    raise 'Invalid role' unless User.roles.keys.include?(new_role)

    target_user.update!(role: new_role)
    "User role has been successfully updated to #{new_role}."
  rescue => e
    e.message
  end
end
