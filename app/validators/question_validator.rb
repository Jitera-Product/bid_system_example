class QuestionValidator < ActiveModel::Validator
  validates :content, presence: { message: "Question content cannot be empty." }
  validate :user_must_exist, :tags_must_exist

  private

  def user_must_exist
    unless User.exists?(record.user_id)
      record.errors.add(:user_id, "User not found.")
    end
  end

  def tags_must_exist
    record.tags.each do |tag_id|
      record.errors.add(:tags, "One or more tags are invalid.") unless Tag.exists?(tag_id)
    end
  end
  # existing code...
end
