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

  # Update validations for image
  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes }, if: :image_attached?

  # New relationships based on updated ERD
  # Assuming that the related models (Admin, User, BidItem, ProductCategory) are already defined
  # and have the necessary inverse relationships set up.

  # New validations or custom methods if required by the updated ERD
  # For example, if there are new constraints or business logic to be enforced at the model level.

  private

  def image_attached?
    image.attached?
  end
end
