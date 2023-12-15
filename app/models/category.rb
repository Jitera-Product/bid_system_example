class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :question_categories, dependent: :destroy # Added relation to question_categories
  belongs_to :admin # Updated relation to match the admin_id field

  # validations

  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  # end for validations

  class << self
  end
end
