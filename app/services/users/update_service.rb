module Users
  class UpdateService
    def initialize(id, params)
      @id = id
      @params = params
    end
    def call
      validate_params
      user = User.find(@id)
      if user.update(@params)
        return { success: true, message: 'User updated successfully' }
      else
        raise StandardError.new('Failed to update user')
      end
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new('User not found')
    end
    private
    def validate_params
      required_fields = ["age", "gender", "location", "interests", "preferences"]
      missing_fields = required_fields - @params.keys
      if missing_fields.any?
        raise StandardError.new("Missing required fields: #{missing_fields.join(', ')}")
      end
    end
  end
end
