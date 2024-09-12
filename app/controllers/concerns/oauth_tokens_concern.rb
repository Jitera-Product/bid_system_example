# frozen_string_literal: true

module OauthTokensConcern
  extend ActiveSupport::Concern

  def current_resource_owner
    doorkeeper_token&.resource_owner
  end
  alias current_user current_resource_owner

  def create_moder_token(moder)
    CustomAccessToken.create!(
      resource_owner_id: moder.id,
      resource_owner_type: 'Moder',
      expires_in: Doorkeeper.configuration.access_token_expires_in,
      scopes: 'moder'
    )
  end
end
