class Api::UsersPasswordsController < Api::BaseController
  def update_password
    user = User.find(params[:id])
    new_password = params.dig(:new_password)
    password_validator = PasswordValidator.new(new_password)
    if password_validator.valid?
      update_password_service = UpdatePasswordService.new(user, new_password)
      if update_password_service.call
        render 'api/users/show', status: :ok
      else
        render json: { messages: update_password_service.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      render json: { messages: password_validator.errors.full_messages },
             status: :unprocessable_entity
    end
  end
end
