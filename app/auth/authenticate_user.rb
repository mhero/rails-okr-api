# frozen_string_literal: true

class AuthenticateUser
  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    user = authenticate_user
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :username, :password

  def authenticate_user
    user = User.find_by(username: username)
    return user if user&.authenticate(password)

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
