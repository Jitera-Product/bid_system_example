class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :update_role]
  before_action :authorize_update_role, only: [:update_role]

  # PATCH/PUT /api/v1/users/1/role
  def update_role
    role = user_params[:role]
    if User.roles.include?(role)
      if @user.update(role: role)
        render json: { status: 200, user: @user.as_json(only: [:id, :username, :role]) }, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid role value.' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found.' }, status: :not_found
  end

  private
    def authorize_update_role
      authorize @user, :update_role?, policy_class: Api::UsersPolicy
    end

  # GET /api/v1/users/1
  def show
    render json: @user
  end

  # POST /api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1
  def destroy
    @user.destroy
    head :no_content
  end

  # Use callbacks to share common setup or constraints between actions
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
