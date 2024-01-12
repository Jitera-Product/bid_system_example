
class Api::V1::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!, only: [:retrieve]

  def retrieve
    query = params[:query]
    begin
      answers = AnswerService::Index.new.retrieve_answers(query)
      render json: answers, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  # Add any additional private methods or before_action calls here
end
