class Api::V1::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!, only: [:search]

  # The 'retrieve' action is no longer needed as per the new requirement
  # and has been replaced by the 'search' action.

  def search
    query = params[:query]
    if query.blank?
      render json: { error: 'The query is required.' }, status: :bad_request
      return
    end

    begin
      answers = AnswerService::Index.new.retrieve_answers(query)
      render json: { status: 200, answers: answers }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  # Add any additional private methods or before_action calls here
end
