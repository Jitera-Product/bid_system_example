class ProductCategory < ApplicationRecord
  belongs_to :category
  belongs_to :product

  # validations
  validates :category_id, presence: { message: I18n.t('activerecord.errors.models.product_category.attributes.category_id.blank') }
  validates :product_id, presence: { message: I18n.t('activerecord.errors.models.product_category.attributes.product_id.blank') }
  validates :category_id, uniqueness: { scope: :product_id, message: I18n.t('activerecord.errors.models.product_category.attributes.category_id_and_product_id.taken') }
  # end for validations

  class << self
  end
end