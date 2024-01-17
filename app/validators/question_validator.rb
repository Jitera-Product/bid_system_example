
class QuestionValidator < ActiveModel::Validator
  validates :content, presence: { message: I18n.t('activerecord.errors.messages.blank') }

  validate :tags_must_exist

  private

  def tags_must_exist
    tags.each { |tag_id| errors.add(:tags, :invalid) unless Tag.exists?(tag_id) }
  end
  # existing code...
end
