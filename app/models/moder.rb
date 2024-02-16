class Moder < ApplicationRecord
  devise :confirmable

  before_create :generate_confirmation_token

  private

  def generate_confirmation_token
    self.confirmation_token = Devise.token_generator.generate(self.class, :confirmation_token)
  end
end
