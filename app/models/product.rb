class Product < ApplicationRecord
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  belongs_to :user
  belongs_to :aproved,
             class_name: 'Admin', optional: true

  has_one_attached :image, dependent: :destroy

  # validations

  validates :name, presence: { message: I18n.t('activerecord.errors.models.product.attributes.name.blank') }

  validates :name, length: { maximum: 255 }, if: :name?

  validates :price, numericality: { greater_than: 0, message: I18n.t('activerecord.errors.models.product.attributes.price.greater_than') }

  validates :description, presence: { message: I18n.t('activerecord.errors.models.product.attributes.description.blank') }

  validates :image, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: I18n.t('activerecord.errors.models.product.attributes.image.invalid') }, if: :image?

  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: I18n.t('activerecord.errors.models.product.attributes.stock.greater_than_or_equal_to') }

  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0, message: I18n.t('activerecord.errors.models.product.attributes.user_id.invalid') }
  validate :user_must_exist

  validates :approved_id, numericality: { only_integer: true, greater_than: 0, message: I18n.t('activerecord.errors.models.product.attributes.approved_id.invalid') }, allow_nil: true
  validate :approved_admin_must_exist, if: :approved_id?

  # end for validations

  class << self
    # Any class methods would be defined here
  end

  private

  def user_must_exist
    errors.add(:user_id, I18n.t('activerecord.errors.models.product.attributes.user_id.invalid')) unless User.exists?(self.user_id)
  end

  def approved_admin_must_exist
    errors.add(:approved_id, I18n.t('activerecord.errors.models.product.attributes.approved_id.invalid')) unless Admin.exists?(self.approved_id)
  end

  # Additional methods, if any, should be added below this line

end