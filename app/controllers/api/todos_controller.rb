class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:link_categories_tags]

  def link_categories_tags
    todo = Todo.find_by(id: params[:todo_id])
    return render status: :not_found, json: { error: 'Todo not found' } if todo.nil?

    category_ids = params[:category_ids]
    tag_ids = params[:tag_ids]

    missing_categories = category_ids - Category.where(id: category_ids).pluck(:id)
    unless missing_categories.empty?
      return render status: :unprocessable_entity, json: { error: "Categories not found: #{missing_categories.join(', ')}" }
    end

    missing_tags = tag_ids - Tag.where(id: tag_ids).pluck(:id)
    unless missing_tags.empty?
      return render status: :unprocessable_entity, json: { error: "Tags not found: #{missing_tags.join(', ')}" }
    end

    ActiveRecord::Base.transaction do
      category_ids.each do |category_id|
        TodoCategory.create!(todo_id: todo.id, category_id: category_id)
      end

      tag_ids.each do |tag_id|
        TodoTag.create!(todo_id: todo.id, tag_id: tag_id)
      end
    end

    linked_categories = todo.categories
    linked_tags = todo.tags

    render status: :ok, json: {
      linked_categories: linked_categories.as_json(only: [:id, :name]),
      linked_tags: linked_tags.as_json(only: [:id, :name])
    }
  rescue => e
    render status: :internal_server_error, json: { error: e.message }
  end
end
