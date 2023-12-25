class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Use strong parameters to permit title, content, and category_id
    question_params = params.require(:question).permit(:title, :content, :category_id)

    # Validate the presence of title and content using the QuestionValidator class
    validator = QuestionValidator.new(question_params)
    unless validator.valid?
      render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
      return
    end

    # Ensure that category_id corresponds to an existing Category record
    unless Category.exists?(question_params[:category_id])
      render json: { error: 'Category not found' }, status: :not_found
      return
    end

    # Create a new entry in the "questions" table with the provided title, content, contributor_id, and timestamps.
    question = Question.new(
      contributor_id: current_user.id,
      title: question_params[:title],
      content: question_params[:content],
      created_at: Time.current, # Use the current time for created_at
      updated_at: Time.current  # Use the current time for updated_at
    )

    if question.save
      # Associate the new question with the selected category by creating an entry in the "question_categories" table linking the question_id and category_id.
      QuestionCategory.create(question_id: question.id, category_id: question_params[:category_id])

      # Return the id of the newly created question as a JSON response
      render json: { id: question.id }, status: :created
    else
      # Handle cases where the question could not be created
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ... other actions in the controller ...
end
