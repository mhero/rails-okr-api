# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request

  def authenticate
    command = AuthenticateUser.new(username: params[:username], password: params[:password]).call

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end