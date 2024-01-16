
class UserPolicy < ApplicationPolicy
  # ... other methods ...

  def update_role?
    user.role == 'admin'
  end

  # ... other methods ...
end
