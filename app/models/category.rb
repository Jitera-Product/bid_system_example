class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :question_categories, dependent: :destroy # New relationship added
  belongs_to :admin # Updated relationship to match the new column admin_id

  # validations

  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?
  validates :description, length: { maximum: 500 }, allow_blank: true # New validation for description
  validates :disabled, inclusion: { in: [true, false] } # New validation for disabled

  # end for validations

  class << self
  end
end
