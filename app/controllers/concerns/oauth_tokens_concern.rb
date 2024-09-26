
# frozen_string_literal: true

module OauthTokensConcern
  extend ActiveSupport::Concern

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  alias current_user current_resource_owner

  included do
    before_action :validate_oauth_token, only: [:create]
  end

  private

  def validate_oauth_token
    raise Exceptions::AuthenticationError unless doorkeeper_token
  end
end
