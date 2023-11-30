class UserValidator
  include ActiveModel::Validations
  attr_accessor :id, :age, :location, :interests, :preferences, :match_id, :feedback
  validates :id, presence: { message: "This user is not found" }, numericality: { only_integer: true, greater_than: 0, message: "Wrong format" }
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0, message: "Wrong format" }
  validates :location, presence: { message: "The location is required." }
  validates :interests, presence: { message: "The interests are required." }
  validates :preferences, presence: { message: "The preferences are required." }
  validates :match_id, presence: { message: "This match is not found" }, numericality: { only_integer: true, greater_than: 0, message: "Wrong format" }
  validates :feedback, presence: { message: "The feedback is required." }
  def initialize(params={})
    @id = params[:id]
    @age = params[:age]
    @location = params[:location]
    @interests = params[:interests]
    @preferences = params[:preferences]
    @match_id = params[:match_id]
    @feedback = params[:feedback]
    super()
  end
  def validate
    valid?
  end
end
