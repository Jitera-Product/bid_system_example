
class AuthenticationService
  def initialize(user)
    @user = user
  end

  def authenticate
    # Authentication logic here
  end

  def contributor?
    @user.role == 'Contributor'
  end

end
