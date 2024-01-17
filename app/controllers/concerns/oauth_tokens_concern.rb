# frozen_string_literal: true

module OauthTokensConcern
  extend ActiveSupport::Concern

  def current_resource_owner
    doorkeeper_token&.resource_owner
  end
  alias current_user current_resource_owner

  def authenticate_inquirer!
    raise Pundit::NotAuthorizedError unless current_user.role == 'inquirer'
  end

  def validate_answer_submission(content, question_id)
    if content.blank?
      render json: { error: 'Content cannot be empty.' }, status: :unprocessable_entity
      return false
    end

    unless Question.exists?(question_id)
      render json: { error: 'Question does not exist.' }, status: :not_found
      return false
    end

    true
  end
end
