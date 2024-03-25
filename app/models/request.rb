
class Request < ApplicationRecord
  # Associations
  belongs_to :user, foreign_key: 'user_id'

  # Validations
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected completed] }
  validates :description, presence: true, length: { maximum: 2000, too_long: I18n.t('activerecord.errors.models.request.attributes.request.description_too_long') }
  validate :validate_visitor_id
  validate :validate_hairstylist_id, if: -> { hair_stylist_id.present? }

  private

  def validate_visitor_id
    errors.add(:visitor_id, I18n.t('activerecord.errors.models.request.attributes.request.invalid_visitor_id')) unless User.exists?(id: visitor_id)
  end

  def validate_hairstylist_id
    errors.add(:hair_stylist_id, I18n.t('activerecord.errors.models.request.attributes.request.invalid_hairstylist_id')) unless User.exists?(id: hair_stylist_id)
  end
end
