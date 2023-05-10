class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, only: %w[show update destroy follow]

  def index
    @users = User.all
    render json: serialize(@users)
  end

  def show
    render json: serialize(@user)
  end

  def create
    @user = User.new user_params
    if @user.save
      render json: serialize(@user), status: :created
    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: serialize(@user), status: :ok
    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render nothing: true, status: :no_content
  end

  def follow
    @user_follower = @user.user_followers.new(follower_id: @current_user.id)

    if @user_follower.save
      render json: serialize(@user), status: :created
    else
      render json: { error: @user_follower.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user ||= User.find(params[:id])
  end
end
