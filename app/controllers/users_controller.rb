class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, only: %w[show update destroy follow unfollow friends_sleeps]

  def index
    @users = User.page(page_number).per(page_size)
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

  def unfollow
    @follower = @user.followers.find_by(id: @current_user.id)

    if @follower.present?
      @user.followers.delete(@follower)

      render json: serialize(@user), status: :ok
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def friends_sleeps
    @sleep_routines = SleepRoutine.records_from_previous_week(@user.followers.ids, page_number, page_size)

    render json: serialize(@sleep_routines), status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user ||= User.find(params[:id])
  end
end
