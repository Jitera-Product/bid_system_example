class UserValidator
  include ActiveModel::Validations
  attr_accessor :id, :age, :gender, :location, :interests, :preferences
  validates :id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :gender, presence: true
  validates :location, presence: true
  validates :interests, presence: true
  validates :preferences, presence: true
  def initialize(params={})
    @id = params[:id]
    @age = params[:age]
    @gender = params[:gender]
    @location = params[:location]
    @interests = params[:interests]
    @preferences = params[:preferences]
    super()
  end
  def validate
    valid?
  end
end
