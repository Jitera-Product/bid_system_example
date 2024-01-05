class TodoService
  # Links a todo with categories and tags
  # @param todo_id [Integer] the ID of the todo
  # @param category_ids [Array<Integer>] the IDs of the categories
  # @param tag_ids [Array<Integer>] the IDs of the tags
  # @return [Hash] a response object with linked category and tag IDs
  def link_todo_with_categories_and_tags(todo_id, category_ids, tag_ids)
    ActiveRecord::Base.transaction do
      todo = Todo.find(todo_id)

      linked_categories = category_ids.map do |category_id|
        category = Category.find(category_id)
        TodoCategory.create!(todo: todo, category: category)
      end

      linked_tags = tag_ids.map do |tag_id|
        tag = Tag.find(tag_id)
        TodoTag.create!(todo: todo, tag: tag)
      end

      { linked_categories: linked_categories.map(&:category_id), linked_tags: linked_tags.map(&:tag_id) }
    end
  rescue ActiveRecord::RecordNotFound => e
    raise "Record not found: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    raise "Record invalid: #{e.message}"
  rescue => e
    raise "An error occurred while linking todo with categories and tags: #{e.message}"
  end

  # Checks if a todo title is unique for a user
  # @param user_id [Integer] the ID of the user
  # @param title [String] the title of the todo
  # @return [Hash] a response object with uniqueness check result
  def check_todo_title_uniqueness(user_id, title)
    todo_exists = Todo.exists?(user_id: user_id, title: title)
    if todo_exists
      { is_unique: false, error: "A todo with the title '#{title}' already exists for this user." }
    else
      { is_unique: true }
    end
  end

  # ... other methods ...
end
