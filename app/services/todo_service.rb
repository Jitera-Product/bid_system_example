# rubocop:disable Style/ClassAndModuleChildren
module Exceptions
  class TodoServiceError < StandardError; end
  class AuthenticationError < StandardError; end
end

class TodoService
  include ActiveModel::Validations

  validate :user_must_be_valid, :title_must_be_unique, :due_date_must_be_future,
           :categories_must_exist, :tags_must_exist, :attachments_must_be_valid

  def initialize(user_id:, title:, description:, due_date:, priority:, recurring:, category_ids:, tag_ids:, attachments:)
    @user_id = user_id
    @title = title
    @description = description
    @due_date = due_date
    @priority = priority
    @recurring = recurring
    @category_ids = category_ids
    @tag_ids = tag_ids
    @attachments = attachments
  end

  def create_todo
    validate_todo_details

    validate!

    Todo.transaction do
      todo = Todo.create!(
        user_id: @user_id,
        title: @title,
        description: @description,
        due_date: @due_date,
        priority: @priority,
        recurring: @recurring
      )

      category_links = link_todo_with_categories_and_tags(todo.id, @category_ids, @tag_ids) if @category_ids.present? || @tag_ids.present?
      attachment_records = create_attachments(todo.id) if @attachments.present?

      {
        id: todo.id,
        title: todo.title,
        description: todo.description,
        due_date: todo.due_date,
        priority: todo.priority,
        recurring: todo.recurring,
        categories: category_links&.dig(:linked_categories),
        tags: category_links&.dig(:linked_tags),
        attachments: attachment_records
      }
    end
  rescue => e
    Rails.logger.error("TodoService::Create failed: #{e.message}")
    raise
  end

  # Validates todo details before creating a todo item
  def validate_todo_details
    title_must_be_unique
    due_date_must_be_future
  rescue StandardError => e
    Rails.logger.error("TodoService::validate_todo_details failed: #{e.message}")
    raise
  end

  # Links a todo with categories and tags
  # @param todo_id [Integer] the ID of the todo
  # @param category_ids [Array<Integer>] the IDs of the categories
  # @param tag_ids [Array<Integer>] the IDs of the tags
  # @return [Hash] a response object with linked category and tag IDs
  def link_todo_with_categories_and_tags(todo_id, category_ids, tag_ids)
    Todo.transaction do
      todo = Todo.find(todo_id)

      linked_categories = category_ids.map do |category_id|
        category = Category.find(category_id)
        TodoCategory.create!(todo: todo, category: category)
      end if category_ids.present?

      linked_tags = tag_ids.map do |tag_id|
        tag = Tag.find(tag_id)
        TodoTag.create!(todo: todo, tag: tag)
      end if tag_ids.present?

      {
        linked_categories: linked_categories&.map(&:category_id), linked_tags: linked_tags&.map(&:tag_id)
      }
    end
  rescue ActiveRecord::RecordNotFound => e
    raise "Record not found: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    raise "Record invalid: #{e.message}"
  rescue => e
    raise "An error occurred while linking todo with categories and tags: #{e.message}"
  end

  private

  def user_must_be_valid
    user = User.find_by(id: @user_id)
    raise Exceptions::AuthenticationError, 'User must be valid and logged in.' if user.nil? || !user_signed_in?(user)
  end

  def title_must_be_unique
    existing_todo = Todo.find_by(user_id: @user_id, title: @title)
    raise StandardError, 'Title must be unique per user.' if existing_todo.present?
  end

  def due_date_must_be_future
    raise StandardError, 'Due date must be in the future.' unless @due_date > Time.current
  end

  # Methods for categories_must_exist, tags_must_exist, attachments_must_be_valid,
  # create_attachments are not shown for brevity but should be implemented following the guidelines provided.
end
# rubocop:enable Style/ClassAndModuleChildren
