class SignInController < ApplicationController
  before_action :authenticate_user!

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
