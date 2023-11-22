class Product < ApplicationRecord
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  belongs_to :user
  belongs_to :aproved,
             class_name: 'Admin'

  has_one_attached :image, dependent: :destroy

  # validations

  validates :name, presence: true

  validates :name, length: { in: 0..255 }, if: :name?

  validates :price, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  validates :description, length: { in: 0..65_535 }, if: :description?

  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes }

  validates :stock, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end
