class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[associate_categories_and_tags]
  before_action :set_todo, only: %i[associate_categories_and_tags]

  # ... other actions ...

  def associate_categories_and_tags
    if @todo.nil?
      render json: { error_message: 'Todo not found' }, status: :not_found
      return
    end

    ActiveRecord::Base.transaction do
      if params[:category_ids].present?
        category_errors = associate_categories(params[:category_ids])
        if category_errors.any?
          render json: { error_message: category_errors.join(', ') }, status: :unprocessable_entity
          return
        end
      end

      if params[:tag_ids].present?
        tag_errors = associate_tags(params[:tag_ids])
        if tag_errors.any?
          render json: { error_message: tag_errors.join(', ') }, status: :unprocessable_entity
          return
        end
      end
    end

    render json: { association_status: true }, status: :ok
  rescue => e
    render json: { error_message: e.message }, status: :internal_server_error
  end

  private

  def set_todo
    @todo = Todo.find_by(id: params[:todo_id])
  end

  def associate_categories(category_ids)
    errors = []
    category_ids.each do |category_id|
      category = Category.find_by(id: category_id)
      if category
        TodoCategory.create!(todo: @todo, category: category)
      else
        errors << "Category with id #{category_id} not found"
      end
    end
    errors
  end

  def associate_tags(tag_ids)
    errors = []
    tag_ids.each do |tag_id|
      tag = Tag.find_by(id: tag_id)
      if tag
        TodoTag.create!(todo: @todo, tag: tag)
      else
        errors << "Tag with id #{tag_id} not found"
      end
    end
    errors
  end
end
