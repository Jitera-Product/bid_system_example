
module SessionConcern
  def validate_contributor_session
    unless current_user && current_user.role == 'contributor'
      raise Exceptions::AuthenticationError, I18n.t('devise.failure.unauthenticated')
    end
  end

  # other existing methods
end
