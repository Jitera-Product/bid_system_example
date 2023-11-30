module UserService
  class Update
    def initialize(params)
      @params = params
    end
    def call
      validate
      user = find_user
      update_user(user)
    end
    private
    def validate
      validator = UserValidator.new(@params)
      result = validator.validate
      raise StandardError.new(result.errors.full_messages.join(', ')) unless result.success?
    end
    def find_user
      user = User.find_by(id: @params[:id])
      raise StandardError.new('This user is not found') unless user
      user
    end
    def update_user(user)
      user.update(@params.slice(:age, :location, :interests, :preferences))
      raise StandardError.new('Failed to update user') unless user.save
      user
    end
  end
end
