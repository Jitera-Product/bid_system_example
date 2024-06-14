class ProductCategory < ApplicationRecord
  belongs_to :category
  belongs_to :product

  # validations
  validates_presence_of :category_id, message: I18n.t('product_category.category_id.presence')
  validates_presence_of :product_id, message: I18n.t('product_category.product_id.presence')
  # end for validations

  class << self
  end
end