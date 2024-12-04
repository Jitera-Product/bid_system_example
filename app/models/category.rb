
class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :todos, dependent: :destroy

  belongs_to :admin
  belongs_to :created,
             class_name: 'Admin'

  attribute :disabled, :boolean, default: false

  # validations

  validates :name, presence: true

  validates :name, length: { in: 0..255 }, if: :name?

  # end for validations

  class << self
  end
end
