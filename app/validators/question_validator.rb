class QuestionValidator
  include ActiveModel::Validations

  validates :content, presence: true

  validate :tags_exist

  def initialize(attributes = {})
    @attributes = attributes
  end

  private

  def tags_exist
    errors.add(:tags, 'contain invalid or non-existent IDs') unless Tag.where(id: @attributes[:tags]).count == @attributes[:tags].size
  end
end
