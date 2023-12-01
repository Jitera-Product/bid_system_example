class Api::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!, only: %i[update]
  def retrieve_answer
    query = params[:query]
    questions = Question.where("content LIKE ?", "%#{query}%")
    answers = Answer.where("content LIKE ?", "%#{query}%")
    # Combine questions and answers into a single array
    results = questions + answers
    # Sort results based on relevance
    sorted_results = results.sort_by { |result| result.content.downcase.include?(query.downcase) ? -1 : 1 }
    # Return the most relevant answer
    most_relevant_answer = sorted_results.first
    if most_relevant_answer.present?
      render json: {answer: most_relevant_answer.content, question_id: most_relevant_answer.question_id, answer_id: most_relevant_answer.id}
    else
      render json: {message: "No relevant answer found"}, status: :not_found
    end
  end
  def update
    @answer = Answer.find_by(id: params[:id], user_id: params[:user_id])
    if @answer.nil?
      render json: { error: 'Answer not found or user not authorized' }, status: :not_found
    else
      if @answer.update(content: params[:content])
        render json: { message: 'Answer updated successfully', id: @answer.id }, status: :ok
      else
        render json: { error: 'Failed to update answer' }, status: :unprocessable_entity
      end
    end
  end
end
