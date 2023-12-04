class Api::UsersPolicy < ApplicationPolicy
  def update?
    (user.is_a?(User) && record.id == user&.id)
  end
  def show?
    (user.is_a?(User) && record.id == user&.id)
  end
  def create?
    (user.is_a?(User) && record.id == user&.id)
  end
  def submit_kyc_info?
    user.kyc_documents.empty?
  end
  def manual_kyc_verification?
    user.is_a?(User) && user.has_role?(:admin)
  end
  def restrict_features?
    user.is_a?(User) && user.has_role?(:admin)
  end
  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.all.where('users.id = ?', user&.id)
      else
        scope.none
      end
    end
  end
end
