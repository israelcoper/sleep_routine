module AuthenticationHelper
  def generate_auth_token(user)
    token = JsonWebToken.encode({ user_id: user.id })

    "Token #{token}"
  end
end
