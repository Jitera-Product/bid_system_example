class Api::UsersRegistrationsController < Api::BaseController
  def create
    @user = User.new(user_params)

    if params[:user][:images].present?
      params[:user][:images].each do |image|
        @user.images.attach(image)
      end
    end

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    else
      render_error_response(:unprocessable_entity, @user.errors.full_messages)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :display_name, :gender, :date_of_birth, :area, :menu)
  end
end
