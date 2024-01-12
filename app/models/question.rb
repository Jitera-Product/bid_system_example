class Question < ApplicationRecord
  # Validations
  validates :title, presence: { message: I18n.t('activerecord.errors.messages.blank') }, on: :update
  validates :content, presence: { message: I18n.t('activerecord.errors.messages.blank') }, on: :update

  # Associations
  belongs_to :user
  has_many :answers, dependent: :destroy

  # ... other associations and code ...
end
