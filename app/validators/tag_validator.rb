class TagValidator
  include ActiveModel::Validations

  validate :validate_tags_existence

  def initialize(tags_array)
    @tags = tags_array
  end

  def validate_tags_existence
    @tags.each do |tag_id|
      errors.add(:base, :invalid_tag_id, message: "Tag with id #{tag_id} does not exist") unless Tag.exists?(tag_id)
    end
  end
end
