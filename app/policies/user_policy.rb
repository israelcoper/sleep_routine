class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def update?
    current_user.id == user.id
  end

  def destroy?
    current_user.id == user.id
  end

  def friends_sleeps?
    current_user.id == user.id
  end

  def sleep_routine?
    current_user.id == user.id
  end
end
