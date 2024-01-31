class Wallet < ApplicationRecord
  belongs_to :user

  # The new code introduces a scope for transactions and deposits where deleted_at is nil.
  # This is likely to support a soft delete mechanism.
  # We need to merge this with the existing relationships.
  has_many :transactions, -> { where(deleted_at: nil) }, dependent: :destroy
  has_many :deposits, -> { where(deleted_at: nil) }, dependent: :destroy

  # validations

  # The new code introduces a validation that doesn't make sense:
  # validates :balance, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }
  # This would mean the balance can only be 0.0, which is likely a mistake.
  # We'll keep the existing validation that ensures the balance is non-negative.
  validates :balance, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0.0 }

  # end for validations

  # The existing code has a soft_delete method which is not present in the new code.
  # We need to ensure this method is kept in the final version.
  def soft_delete
    update(deleted_at: Time.current)
  end

  class << self
    # If there are any class methods in either version, they should be included here.
    # Since neither the new code nor the existing code have any, this section remains empty.
  end
end
