class QuestionValidator
  include ActiveModel::Validations

  validates :content, presence: true
  validate :tags_exist_and_valid

  def initialize(attributes = {})
    @attributes = attributes
  end

  def validate(content, tags)
    raise 'Content cannot be empty' if content.blank?

    tags.each do |tag_id|
      raise 'Invalid tag_id' unless Tag.exists?(tag_id)
    end
  end

  private

  def tags_exist_and_valid
    if @attributes[:tags].present?
      # Check if all tags exist
      unless Tag.where(id: @attributes[:tags]).count == @attributes[:tags].size
        errors.add(:tags, 'contain invalid or non-existent IDs')
      end
    else
      # If tags are not present, add an error
      errors.add(:tags, 'must be provided')
    end
  end
end
