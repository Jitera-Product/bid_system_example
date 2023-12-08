class TodoCreationService
  include AuthenticationHelper

  def create_todo(user_id:, title:, description: nil, due_date:, priority:, recurring: nil, category_ids: [], tag_ids: [], attachments: [])
    validation_status = true
    error_message = nil

    # Authenticate user
    unless authenticate_user(user_id)
      return { validation_status: false, error_message: "User authentication failed." }
    end

    # Instantiate validators
    todo_validator = TodoValidator.new
    title_uniqueness_validator = TodoTitleUniquenessValidator.new
    due_date_validator = TodoDueDateValidator.new
    priority_validator = PriorityValidator.new # Assuming PriorityValidator exists

    # Validate mandatory fields
    unless todo_validator.validate_mandatory_fields(title, due_date)
      validation_status = false
      error_message = "Title and due date are mandatory."
    end

    # Validate title uniqueness
    if validation_status && !title_uniqueness_validator.validate_title_uniqueness(user_id, title)
      validation_status = false
      error_message = "Title already exists."
    end

    # Validate due date
    if validation_status && !due_date_validator.validate_due_date(due_date)
      validation_status = false
      error_message = "Due date is not valid."
    end

    # Validate priority
    if validation_status && !priority_validator.validate_priority(priority)
      validation_status = false
      error_message = "Priority is not valid."
    end

    # Validate recurring if provided
    if recurring && validation_status && !todo_validator.validate_recurring(recurring)
      validation_status = false
      error_message = "Recurring is not valid."
    end

    # Validate category_ids and tag_ids
    if validation_status
      category_ids.each do |category_id|
        unless Category.exists?(category_id)
          validation_status = false
          error_message = "Category with id #{category_id} does not exist."
          break
        end
      end
    end

    if validation_status
      tag_ids.each do |tag_id|
        unless Tag.exists?(tag_id)
          validation_status = false
          error_message = "Tag with id #{tag_id} does not exist."
          break
        end
      end
    end

    # Proceed with todo creation if validations pass
    if validation_status
      todo = Todo.new(user_id: user_id, title: title, description: description, due_date: due_date, priority: priority, recurring: recurring)
      if todo.save
        # Create associations for categories
        category_ids.each do |category_id|
          TodoCategory.create(todo_id: todo.id, category_id: category_id)
        end

        # Create associations for tags
        tag_ids.each do |tag_id|
          TodoTag.create(todo_id: todo.id, tag_id: tag_id)
        end

        # Process attachments
        ProcessAttachmentsJob.perform_later(todo.id, attachments)

        # Return the success message with todo_id
        return { validation_status: true, todo_id: todo.id, message: "Todo item created successfully." }
      else
        validation_status = false
        error_message = todo.errors.full_messages.join(", ")
      end
    end

    # Return the result
    { validation_status: validation_status, error_message: error_message }
  end

  private

  def authenticate_user(user_id)
    # Assuming AuthenticationHelper provides a method `authenticate` to verify user permissions
    authenticate(user_id)
  end
end
