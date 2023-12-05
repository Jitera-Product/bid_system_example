class Product < ApplicationRecord
  # Existing relationships
  belongs_to :admin
  belongs_to :user
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  # Existing validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, if: :name?
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 65_535 }, if: :description?
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Existing attachment
  has_one_attached :image, dependent: :destroy

  # Update validations for image
  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes }, if: :image_attached?

  private

  def image_attached?
    image.attached?
  end
end
