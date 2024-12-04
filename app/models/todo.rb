
class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :title, presence: { message: I18n.t('activerecord.errors.messages.blank') }, uniqueness: { scope: :user_id, message: I18n.t('activerecord.errors.messages.taken') }
  validates :description, presence: true
  validates :due_date, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :priority, presence: true
  validates :recurring, inclusion: { in: [true, false] }
  validate :due_date_in_future
  validate :category_exists_and_enabled, if: -> { category_id.present? }

  private

  def due_date_in_future
    errors.add(:due_date, I18n.t('activerecord.errors.messages.datetime_in_future')) if due_date.present? && due_date < Time.zone.now
  end

  def category_exists_and_enabled
    errors.add(:category_id, I18n.t('activerecord.errors.messages.invalid')) unless Category.exists?(id: category_id, disabled: false)
  end
end
