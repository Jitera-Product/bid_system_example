class ProductCategory < ApplicationRecord
  belongs_to :category
  belongs_to :product

  # validations

  # end for validations

  class << self
  end
end
