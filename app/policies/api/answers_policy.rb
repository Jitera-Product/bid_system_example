class Api::AnswersPolicy < ApplicationPolicy
  def create?
    user.role == 'contributor'
  end
end
