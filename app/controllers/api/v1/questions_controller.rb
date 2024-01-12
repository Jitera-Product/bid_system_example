# typed: true
# frozen_string_literal: true

class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :set_question, only: [:update]
  before_action :authorize_question, only: [:update]
  before_action :validate_question_params, only: [:create, :update]
  before_action :doorkeeper_authorize!, except: [:create, :update]

  def create
    authorize :question, :create?
    service = QuestionSubmissionService.new(question_params, current_resource_owner.id)
    question = service.call
    render json: { status: 201, question: question }, status: :created
  rescue Pundit::NotAuthorizedError
    render json: { error: 'User is not authorized to create questions.' }, status: :forbidden
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    if @question.update_question(question_params)
      render json: { message: 'Question updated successfully', question: @question }, status: :ok
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
  def set_question
    @question = QuestionRetrievalService.get_question(params[:id])
    render json: { error: 'Question not found' }, status: :not_found unless @question
  end

  def authorize_question
    render json: { error: 'Forbidden' }, status: :forbidden unless QuestionPolicy.new(current_user, @question).edit?
  end

  def validate_question_params
    validator = QuestionValidator.new(params)
    if validator.valid?
      validate_tags if params[:tags]
    else
      render json: { errors: validator.errors }, status: :bad_request
    end
  end

  def validate_tags
    unless params[:tags].is_a?(Array) && params[:tags].all? { |tag| tag.is_a?(Integer) }
      render json: { errors: 'Tags must be an array of tag IDs.' }, status: :bad_request
    end
  end

  def question_params
    if action_name == 'create'
      params.permit(:title, :content, :category, tags: [])
    else
      params.require(:question).permit(:title, :content, :category, tags: [])
    end
  end
end
