# frozen_string_literal: true

class AuthenticateUser
  prepend SimpleCommand

  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: authenticated_user.id)
  end

  private

  attr_reader :username, :password

  def authenticated_user
    user = User.find_by(username: username)
    return user if user&.authenticate(password)

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
