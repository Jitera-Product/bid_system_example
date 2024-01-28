class BidItem < ApplicationRecord
  has_many :item_bids,
           class_name: 'Bid',
           foreign_key: :item_id, dependent: :destroy
  has_many :chat_sessions, dependent: :destroy

  belongs_to :user
  belongs_to :product

  enum status: %w[draft ready done], _suffix: true

  # validations

  validates :base_price, presence: true

  # The numericality validation for base_price in the new code is incorrect as it does not allow for a range of values.
  # It should be greater_than_or_equal_to: 0.0 without the upper limit of 0.0.
  # Therefore, we keep the existing validation which allows any value greater than or equal to 0.0.
  validates :base_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :status, presence: true
  validates :expiration_time, presence: true

  # The new code adds a timeliness validation for expiration_time which we will include.
  # This ensures that the expiration_time is on or after tomorrow.
  validates :expiration_time, presence: true, timeliness: { type: :datetime, on_or_after: DateTime.tomorrow }

  validates :name, presence: true

  # The length validation for name is conditional based on the presence of name, which is a good practice.
  # We will keep this conditional validation from the new code.
  validates :name, length: { in: 0..255 }, if: :name?
  validates :product_id, presence: true
  validates :user_id, presence: true

  # end for validations

  def close_bid_item
    update!(status: 'done')
    # The new code uses a find_each loop to update chat_sessions, which is more efficient for large datasets.
    # However, the existing code uses update_all which is more performant as it generates a single SQL update statement.
    # We will combine the two approaches by using update_all and keeping the condition check from the existing code.
    chat_sessions.update_all(is_active: false) if status_done?
  rescue StandardError => e
    # The existing code adds the error message directly, while the new code adds a custom message.
    # We will keep the custom message for more clarity.
    errors.add(:base, "Failed to close bid item: #{e.message}")
    false
  end

  def status_done?
    status == 'done'
  end

  # Additional methods or scopes can be added here

  class << self
  end
end
