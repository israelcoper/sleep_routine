class SleepRoutinesController < ApplicationController
  before_action :authorize_request
  before_action :set_user

  def create
    @sleep_routine = @user.sleep_routines.build(start_at: DateTime.now)

    if @sleep_routine.save
      render json: serialize(@sleep_routine), status: :created
    else
      render json: { error: @sleep_routine.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user ||= User.find(@current_user.id)
  end
end
